function roadmap --description 'Show open GitHub or GitLab issues grouped by milestone'
    if test (count $argv) -gt 0
        if test (count $argv) -ne 1; or test "$argv[1]" != "--prompt"
            echo "Usage: roadmap [--prompt]" >&2
            return 2
        end

        printf '%s\n' \
            "Organise une roadmap du projet directement dans GitHub ou GitLab, selon le dépôt." \
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
        return 0
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

    if not type -q $cli
        echo "roadmap: missing dependency: $cli" >&2
        return 1
    end

    set -l temp_dir (command mktemp -d)
    or return 1
    set -l issues "$temp_dir/issues.ndjson"
    set -l milestones "$temp_dir/milestones.ndjson"
    set -l result 0

    if test "$provider" = gitlab
        command glab api 'projects/:id/milestones?include_parent_milestones=true&per_page=100' --paginate --output ndjson >"$milestones"
        or set result 1

        if test $result -eq 0
            command glab api 'projects/:id/issues?state=opened&order_by=relative_position&sort=asc&per_page=100' --paginate --output ndjson >"$issues"
            or set result 1
        end
    else
        command gh api 'repos/{owner}/{repo}/milestones?state=all&per_page=100' --paginate --slurp >"$temp_dir/milestones.json"
        or set result 1

        if test $result -eq 0
            command jq -cr '.[][] | {id: .number, title: .title}' "$temp_dir/milestones.json" >"$milestones"
            or set result 1
        end

        if test $result -eq 0
            command gh api 'repos/{owner}/{repo}/issues?state=open&sort=created&direction=asc&per_page=100' --paginate --slurp >"$temp_dir/issues.json"
            or set result 1
        end

        if test $result -eq 0
            # GitHub's API does not expose milestone drag-and-drop order.
            command jq -cr '.[][] | select(.pull_request == null) | {
                iid: .number,
                title: .title,
                relative_position: .number,
                milestone: (if .milestone == null then null else {id: .milestone.number} end)
            }' "$temp_dir/issues.json" >"$issues"
            or set result 1
        end

        if test $result -eq 0
            echo "roadmap: GitHub issues sorted by number (manual milestone order is unavailable via API)" >&2
        end
    end

    if test $result -eq 0
        command jq -rs --slurpfile milestones "$milestones" '
            def issue_lines:
                sort_by(.relative_position // 2147483647, .iid)
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
