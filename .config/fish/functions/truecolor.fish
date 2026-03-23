function truecolor --description "Test true color support in terminal"
    for i in (seq 0 255)
        set green (math 255 - $i)
        set blue (math "$i < 128 ? $i * 2 : 510 - $i * 2")
        printf "\x1b[48;2;$i;$green;$blue"m " \x1b[0m"
    end
    echo
end
