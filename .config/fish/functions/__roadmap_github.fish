function __roadmap_github --description 'Read GitHub Project roadmap in manual position order'
    set -l repo (command gh repo view --json nameWithOwner --jq '.nameWithOwner')
    or return 1
    set -l parts (string split -m1 / -- "$repo")
    if test (count $parts) -ne 2
        echo "roadmap: cannot identify the GitHub repository" >&2
        return 1
    end

    set -l temp_dir (command mktemp -d)
    or return 1
    set -l result 0

    command gh api graphql \
        -f query='query($owner:String!, $name:String!) {
            repository(owner:$owner, name:$name) {
                projectsV2(first:100) {
                    nodes { id title closed }
                    pageInfo { hasNextPage }
                }
            }
        }' \
        -f owner="$parts[1]" -f name="$parts[2]" >"$temp_dir/projects.json"
    or set result 1

    if test $result -eq 0
        if not command jq -e '.data.repository.projectsV2.pageInfo.hasNextPage == false' "$temp_dir/projects.json" >/dev/null
            echo "roadmap: too many linked GitHub Projects to select automatically" >&2
            set result 1
        end
    end

    if test $result -eq 0
        set -l project_id (command jq -r '
            [.data.repository.projectsV2.nodes[]? | select(.closed == false)] as $projects
            | if ($projects | length) == 1 then
                $projects[0].id
              else
                [$projects[] | select(.title | test("roadmap"; "i"))] as $roadmaps
                | if ($roadmaps | length) == 1 then $roadmaps[0].id else empty end
              end
        ' "$temp_dir/projects.json")
        if test -z "$project_id"
            echo "roadmap: no unique linked GitHub Project found for $repo" >&2
            set result 1
        else
            command gh api graphql --paginate --slurp \
                -F projectId="$project_id" \
                -f query='query($projectId:ID!, $endCursor:String) {
                    node(id:$projectId) {
                        ... on ProjectV2 {
                            title
                            fields(first:100) {
                                nodes {
                                    ... on ProjectV2SingleSelectField {
                                        name
                                        options { name }
                                    }
                                }
                            }
                            items(first:100, after:$endCursor, orderBy:{field:POSITION,direction:ASC}) {
                                nodes {
                                    type
                                    content {
                                        ... on Issue {
                                            number
                                            title
                                            state
                                            repository { nameWithOwner }
                                        }
                                    }
                                    fieldValueByName(name:"Étape") {
                                        ... on ProjectV2ItemFieldSingleSelectValue { name }
                                    }
                                }
                                pageInfo { hasNextPage endCursor }
                            }
                        }
                    }
                }' >"$temp_dir/items.json"
            or set result 1
        end
    end

    if test $result -eq 0
        command jq -r --arg repo "$repo" '
            def issue_line: "  [ ] #\(.content.number) \(.content.title)";
            . as $pages
            | $pages[0].data.node.title as $project
            | ([$pages[0].data.node.fields.nodes[]?
                | select(.name == "Étape") | .options[].name]) as $stages
            | ([$pages[].data.node.items.nodes[]?
                | select(.type == "ISSUE"
                    and .content.state == "OPEN"
                    and .content.repository.nameWithOwner == $repo)]) as $issues
            | (
                [$stages[] as $stage
                    | "## \($stage)\n"
                      + ([$issues[] | select(.fieldValueByName.name == $stage) | issue_line]
                         | if length == 0 then "  (aucune issue)" else join("\n") end)]
                + ([$issues[]
                    | select(.fieldValueByName.name as $name | ($stages | index($name)) == null)]
                   | if length > 0 then
                         ["## Sans étape\n" + (map(issue_line) | join("\n"))]
                     else [] end)
            )
            | if length == 0 then
                  "Project : \($project)\n\nAucune issue ouverte."
              else
                  "Project : \($project)\n\n" + join("\n\n")
              end
        ' "$temp_dir/items.json"
        or set result 1
    end

    command rm -f -- "$temp_dir/projects.json" "$temp_dir/items.json"
    command rmdir -- "$temp_dir"
    return $result
end
