function roadmap --description 'Show open GitHub Project or GitLab milestone issues by priority'
    if test (count $argv) -gt 0
        if test (count $argv) -ne 1; or test "$argv[1]" != "--prompt"
            echo "Usage: roadmap [--prompt]" >&2
            return 2
        end
    end

    for tool in git jq
        if not type -q $tool
            echo "roadmap: missing dependency: $tool" >&2
            return 1
        end
    end

    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "roadmap: run this command inside a Git repository" >&2
        return 1
    end

    set -l origin (command git remote get-url origin 2>/dev/null)
    set -l provider
    set -l cli
    if string match -qr '(^|[/:@])github\.com[:/]' -- "$origin"
        set provider github
        set cli gh
    else if string match -qr '(^|[/:@])gitlab\.com[:/]' -- "$origin"
        set provider gitlab
        set cli glab
    else
        echo "roadmap: origin is not a supported GitHub or GitLab remote" >&2
        return 1
    end

    if test (count $argv) -eq 1
        if test "$provider" = github
            printf '%s\n' \
                "Organise la roadmap de ce dépôt directement dans GitHub Projects, sans utiliser les milestones pour cette organisation." \
                "" \
                "- Réutilise le Project du dépôt s'il existe, sinon crée-en un." \
                "- Ajoute les issues existantes au Project, sans les dupliquer." \
                "- Utilise un champ **Étape** pour regrouper les issues par phases fonctionnelles." \
                "- Définis un **ordre de priorité manuel** dans chaque étape, en tenant compte des dépendances techniques." \
                "- Configure une vue Table regroupée par étape, en conservant cet ordre manuel." \
                "- Prévois l'ajout automatique des nouvelles issues au Project si possible." \
                "- Évite les doublons, les issues de coordination inutiles et les documents Markdown de roadmap." \
                "" \
                "Analyse le dépôt et organise son Project comme tu le juges pertinent." \
                "" \
                "Présente-moi ensuite les étapes et l'ordre des issues."
        else
            printf '%s\n' \
                "Organise une roadmap du projet directement dans GitLab." \
                "" \
                "- Utilise les **milestones** pour regrouper les issues par étapes fonctionnelles." \
                "- Répartis les issues existantes dans les milestones correspondantes." \
                "- Définis un **ordre de priorité cohérent** pour les issues de chaque milestone, en tenant compte des dépendances techniques." \
                "- Réutilise l'existant et évite les doublons ou les issues de coordination inutiles." \
                "- Ne crée pas de document Markdown séparé pour la roadmap." \
                "" \
                "Analyse le projet et organise les milestones et les issues comme tu le juges pertinent." \
                "" \
                "Présente-moi ensuite la roadmap proposée, avec les étapes et l'ordre des issues."
        end
        return 0
    end

    if not type -q $cli
        echo "roadmap: missing dependency: $cli" >&2
        return 1
    end

    if test "$provider" = github
        __roadmap_github
        return $status
    end

    set -l temp_dir (command mktemp -d)
    or return 1
    set -l issues "$temp_dir/issues.ndjson"
    set -l milestones "$temp_dir/milestones.ndjson"
    set -l result 0

    command glab api 'projects/:id/milestones?include_parent_milestones=true&per_page=100' --paginate --output ndjson >"$milestones"
    or set result 1

    if test $result -eq 0
        command glab api 'projects/:id/issues?state=opened&order_by=relative_position&sort=asc&per_page=100' --paginate --output ndjson >"$issues"
        or set result 1
    end

    if test $result -eq 0
        command jq -rs --slurpfile milestones "$milestones" '
            # Respect an explicit "Priority N" on the first description line.
            # Preserve API order for equally ranked or unranked issues.
            def issue_priority:
                ((.description // ""
                  | split("\n")[0]
                  | try (capture("priority:?\\s+(?<number>[0-9]+)"; "i").number | tonumber) catch null
                ) // 2147483647);

            def issue_lines:
                to_entries
                | sort_by([(.value | issue_priority), .key])
                | map(.value)
                | if length == 0 then
                    "  (aucune issue)"
                  else
                    map("  [\(if .state == "closed" then "x" else " " end)] #\(.iid) \(.title)")
                    | join("\n")
                  end;

            . as $issues
            | (
                (
                    $milestones + [$issues[].milestone | select(. != null)]
                    | unique_by(.id)
                    | sort_by(
                        if (.title | test("^[0-9]+")) then 0 else 1 end,
                        if (.title | test("^[0-9]+")) then
                            (.title | capture("^(?<order>[0-9]+)").order | tonumber)
                        else
                            .id
                        end
                    )
                    | map(
                        . as $milestone
                        | "## \($milestone.title)\n"
                          + ([$issues[] | select(.milestone.id == $milestone.id)] | issue_lines)
                    )
                )
                + (
                    [$issues[] | select(.milestone == null)] as $unassigned
                    | if ($unassigned | length) > 0 then
                        ["## Sans milestone\n" + ($unassigned | issue_lines)]
                      else
                        []
                      end
                )
            )
            | if length == 0 then "Aucune milestone ni issue." else join("\n\n") end
        ' "$issues"
        or set result 1
    end

    command rm -f -- "$issues" "$milestones" "$temp_dir/issues.json" "$temp_dir/milestones.json"
    command rmdir -- "$temp_dir"
    return $result
end
