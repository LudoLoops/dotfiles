# GitHub Projects / GitLab milestones roadmap for Zsh (Atlas).
# Sourced by Home Manager from the shared dotfiles input.
function roadmap() {
  emulate -L zsh

  if (( $# > 1 )) || { (( $# == 1 )) && [[ "$1" != "--prompt" ]]; }; then
    print -u2 "Usage: roadmap [--prompt]"
    return 2
  fi

  for tool in git jq; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      print -u2 "roadmap: missing dependency: $tool"
      return 1
    fi
  done

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print -u2 "roadmap: run inside a Git repository"
    return 1
  fi

  local origin provider cli
  origin=$(git remote get-url origin 2>/dev/null) || {
    print -u2 "roadmap: no origin remote"
    return 1
  }
  if [[ "$origin" =~ '(^|[/:@])github\.com[:/]' ]]; then
    provider=github
    cli=gh
  elif [[ "$origin" =~ '(^|[/:@])gitlab\.com[:/]' ]]; then
    provider=gitlab
    cli=glab
  else
    print -u2 "roadmap: unsupported origin (expected GitHub or GitLab)"
    return 1
  fi

  if [[ "${1:-}" == "--prompt" ]]; then
    if [[ "$provider" == github ]]; then
      cat <<'PROMPT'
Organise la roadmap de ce dépôt directement dans GitHub Projects, sans utiliser les milestones pour cette organisation.

- Réutilise le Project du dépôt s'il existe, sinon crée-en un.
- Ajoute les issues existantes au Project, sans les dupliquer.
- Utilise un champ **Étape** pour regrouper les issues par phases fonctionnelles.
- Définis un **ordre de priorité manuel** dans chaque étape, en tenant compte des dépendances techniques.
- Configure une vue Table regroupée par étape, en conservant cet ordre manuel.
- Prévois l'ajout automatique des nouvelles issues au Project si possible.
- Évite les doublons, les issues de coordination inutiles et les documents Markdown de roadmap.

Analyse le dépôt et organise son Project comme tu le juges pertinent.

Présente-moi ensuite les étapes et l'ordre des issues.
PROMPT
    else
      cat <<'PROMPT'
Organise une roadmap du projet directement dans GitLab.

- Utilise les **milestones** pour regrouper les issues par étapes fonctionnelles.
- Répartis les issues existantes dans les milestones correspondantes.
- Définis un **ordre de priorité cohérent** pour les issues de chaque milestone, en tenant compte des dépendances techniques.
- Réutilise l'existant et évite les doublons ou les issues de coordination inutiles.
- Ne crée pas de document Markdown séparé pour la roadmap.

Analyse le projet et organise les milestones et les issues comme tu le juges pertinent.

Présente-moi ensuite la roadmap proposée, avec les étapes et l'ordre des issues.
PROMPT
    fi
    return 0
  fi

  if ! command -v "$cli" >/dev/null 2>&1; then
    print -u2 "roadmap: missing dependency: $cli"
    return 1
  fi

  local tmp repo owner name project_id
  tmp=$(mktemp -d) || return 1

  if [[ "$provider" == github ]]; then
    repo=$(gh repo view --json nameWithOwner --jq '.nameWithOwner') || { rm -r -- "$tmp"; return 1; }
    owner=${repo%%/*}
    name=${repo#*/}

    if ! gh api graphql -f query='query($owner:String!, $name:String!) {
      repository(owner:$owner, name:$name) {
        projectsV2(first:100) {
          nodes { id title closed }
          pageInfo { hasNextPage }
        }
      }
    }' -f owner="$owner" -f name="$name" > "$tmp/projects.json"; then
      rm -r -- "$tmp"
      return 1
    fi
    if ! jq -e '.errors == null and .data.repository.projectsV2.pageInfo.hasNextPage == false' "$tmp/projects.json" >/dev/null; then
      print -u2 "roadmap: unable to read linked Projects (check gh auth scopes: read:project)"
      rm -r -- "$tmp"
      return 1
    fi

    project_id=$(jq -r '
      [.data.repository.projectsV2.nodes[] | select(.closed == false)] as $projects
      | if ($projects | length) == 1 then $projects[0].id
        else [$projects[] | select(.title | test("roadmap"; "i"))] as $roadmaps
          | if ($roadmaps | length) == 1 then $roadmaps[0].id else empty end
        end
    ' "$tmp/projects.json")
    if [[ -z "$project_id" ]]; then
      print -u2 "roadmap: no unique linked GitHub Project found for $repo"
      rm -r -- "$tmp"
      return 1
    fi

    if ! gh api graphql --paginate --slurp -F projectId="$project_id" -f query='
      query($projectId:ID!, $endCursor:String) {
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
                    number title state repository { nameWithOwner }
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
      }' > "$tmp/items.json"; then
      rm -r -- "$tmp"
      return 1
    fi
    if ! jq -e 'all(.[]; .errors == null)' "$tmp/items.json" >/dev/null; then
      print -u2 "roadmap: failed to read GitHub Project items"
      rm -r -- "$tmp"
      return 1
    fi

    jq -r --arg repo "$repo" '
      def issue_line: "  [ ] #\(.content.number) \(.content.title)";
      . as $pages
      | $pages[0].data.node.title as $project
      | ([$pages[0].data.node.fields.nodes[]?
          | select(.name == "Étape") | .options[].name]) as $stages
      | ([$pages[].data.node.items.nodes[]?
          | select(.type == "ISSUE" and .content.state == "OPEN"
            and .content.repository.nameWithOwner == $repo)]) as $issues
      | (
          [$stages[] as $stage
            | "## \($stage)\n" +
              ([$issues[] | select(.fieldValueByName.name == $stage) | issue_line]
                | if length == 0 then "  (aucune issue)" else join("\n") end)]
          + ([$issues[]
              | select(.fieldValueByName.name as $name | ($stages | index($name)) == null)]
              | if length > 0 then ["## Sans étape\n" + (map(issue_line) | join("\n"))]
                else [] end)
        )
      | if length == 0 then "Project : \($project)\n\nAucune issue ouverte."
        else "Project : \($project)\n\n" + join("\n\n") end
    ' "$tmp/items.json"
  else
    if ! glab api 'projects/:id/milestones?include_parent_milestones=true&per_page=100' --paginate --output ndjson > "$tmp/milestones.ndjson"; then
      rm -r -- "$tmp"
      return 1
    fi
    if ! glab api 'projects/:id/issues?state=opened&order_by=relative_position&sort=asc&per_page=100' --paginate --output ndjson > "$tmp/issues.ndjson"; then
      rm -r -- "$tmp"
      return 1
    fi

    jq -rs --slurpfile milestones "$tmp/milestones.ndjson" '
      def issue_lines:
        sort_by(.relative_position // 2147483647, .iid)
        | if length == 0 then "  (aucune issue)"
          else map("  [ ] #\(.iid) \(.title)") | join("\n") end;
      . as $issues
      | (
          ($milestones + [$issues[].milestone | select(. != null)]
            | unique_by(.id)
            | sort_by(
                if (.title | test("^[0-9]+")) then 0 else 1 end,
                if (.title | test("^[0-9]+")) then
                  (.title | capture("^(?<order>[0-9]+)").order | tonumber)
                else .id end)
            | map(. as $milestone | "## \($milestone.title)\n"
                + ([$issues[] | select(.milestone.id == $milestone.id)] | issue_lines)))
          + ([$issues[] | select(.milestone == null)] as $unassigned
            | if length > 0 then ["## Sans milestone\n" + ($unassigned | issue_lines)]
              else [] end)
        )
      | if length == 0 then "Aucune milestone ni issue."
        else join("\n\n") end
    ' "$tmp/issues.ndjson"
  fi

  local result=$?
  rm -r -- "$tmp"
  return $result
}
