function roadmap --description 'Show GitLab issues grouped by milestone and priority'
    for tool in git glab jq
        if not type -q $tool
            echo "roadmap: missing dependency: $tool" >&2
            return 1
        end
    end

    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "roadmap: run this command inside a GitLab repository" >&2
        return 1
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

    command rm -f -- "$issues" "$milestones"
    command rmdir -- "$temp_dir"
    return $result
end
