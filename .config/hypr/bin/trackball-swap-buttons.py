#!/usr/bin/env python3
"""Echange le clic droit et le bouton lateral du trackball Kensington SlimBlade Pro.

Remap au niveau NOYAU (EVIOCSKEYCODE) sur l'interface souris du trackball :
aucun grab, aucun device virtuel, aucun daemon. Le pire cas en cas d'erreur est
"aucun effet" (pas de souris morte), contrairement a Input Remapper qui grabbe le
device et cree un uinput.

Le remap est propre au peripherique : les autres souris (CX 2.4G) et le touchpad
ne sont pas touches.

Scancodes HID remontes en MSC_SCAN (page Button 0x09) :
  0x90001 BTN_LEFT   0x90002 BTN_RIGHT   0x90003 BTN_MIDDLE
  0x90004 BTN_SIDE   0x90005 BTN_EXTRA

usage: trackball-swap-buttons.py [swap|status|off]   (defaut: swap)
"""
import fcntl
import glob
import os
import struct
import sys

MATCH_NAME = "SlimBlade"        # nom de l'interface souris du trackball
BTN_LEFT = 272                  # sert a identifier la bonne interface
SCAN_RIGHT, SCAN_SIDE = 0x90002, 0x90004
BTN_RIGHT, BTN_SIDE = 273, 275

EVIOCSKEYCODE = 0x40084504      # _IOW('E', 0x04, unsigned int[2])
EVIOCGKEYCODE = 0x80084504      # _IOR('E', 0x04, unsigned int[2])


def _capabilities_key(path):
    """Codes EV_KEY declares par le device.

    Attention : sysfs ecrit les bitmaps en mots de poids FORT en premier,
    il faut inverser l'ordre pour lire les codes correctement.
    """
    with open(os.path.join(path, "capabilities/key")) as fh:
        words = [int(w, 16) for w in reversed(fh.read().split())]
    codes = set()
    for index, word in enumerate(words):
        for bit in range(64):
            if (word >> bit) & 1:
                codes.add(index * 64 + bit)
    return codes


def find_device():
    """Trouve /dev/input/eventN de l'interface SOURIS du trackball."""
    for path in sorted(glob.glob("/sys/class/input/event*/device")):
        try:
            with open(os.path.join(path, "name")) as fh:
                name = fh.read().strip()
            if MATCH_NAME.lower() not in name.lower():
                continue
            if BTN_LEFT not in _capabilities_key(path):
                continue        # ce n'est pas l'interface souris (keyboard / abs / consumer)
            return "/dev/input/" + os.path.basename(os.path.dirname(path))
        except OSError:
            continue
    return None


def get_keycode(fd, scancode):
    out = fcntl.ioctl(fd, EVIOCGKEYCODE, struct.pack("II", scancode, 0))
    return struct.unpack("II", out)[1]


def set_keycode(fd, scancode, keycode):
    fcntl.ioctl(fd, EVIOCSKEYCODE, struct.pack("II", scancode, keycode))


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "swap"
    if mode not in ("swap", "status", "off"):
        print(__doc__)
        return 2

    device = find_device()
    if not device:
        print("trackball-swap-buttons: trackball Kensington introuvable (debranche ?)")
        return 1

    fd = os.open(device, os.O_RDWR)
    try:
        if mode == "status":
            print("%s : scancode 0x%x -> keycode %d" % (device, SCAN_RIGHT, get_keycode(fd, SCAN_RIGHT)))
            print("%s : scancode 0x%x -> keycode %d" % (device, SCAN_SIDE, get_keycode(fd, SCAN_SIDE)))
        elif mode == "swap":
            set_keycode(fd, SCAN_RIGHT, BTN_SIDE)
            set_keycode(fd, SCAN_SIDE, BTN_RIGHT)
            print("trackball-swap-buttons: clic droit <-> bouton lateral actifs (%s)" % device)
        else:  # off
            set_keycode(fd, SCAN_RIGHT, BTN_RIGHT)
            set_keycode(fd, SCAN_SIDE, BTN_SIDE)
            print("trackball-swap-buttons: remis d'origine (%s)" % device)
    finally:
        os.close(fd)
    return 0


if __name__ == "__main__":
    sys.exit(main())
