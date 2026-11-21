#!/usr/bin/env bash
# Publish this static website to the owner's GitHub account using GitHub CLI.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

repo="a6zubair/sparkling-shine"
owner="a6zubair"
expected_remote="https://github.com/${repo}.git"

for dependency in gh git; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    printf 'Install %s before running this script.\n' "$dependency" >&2
    exit 1
  fi
done

# Check both authentication and connectivity before changing anything.
if ! active_user="$(gh api user --jq .login)"; then
  printf 'GitHub is unreachable or authentication is missing. Check your network, then run: gh auth login\n' >&2
  exit 1
fi
if [[ "$active_user" != "$owner" ]]; then
  printf 'Expected GitHub account %s, but the active account is %s. Run: gh auth switch --user %s\n' "$owner" "$active_user" "$owner" >&2
  exit 1
fi

# Never adopt an existing, unrelated repository just because its name matches.
if [[ ! -d .git ]]; then
  if gh repo view "$repo" --json name >/dev/null 2>&1; then
    printf '%s already exists. Clone that repository and review its contents before adding this site.\n' "$repo" >&2
    exit 1
  fi
  git init -b main
fi

if [[ "$(git branch --show-current)" != "main" ]]; then
  printf 'Switch this site checkout to the main branch before publishing.\n' >&2
  exit 1
fi
if git remote get-url origin >/dev/null 2>&1; then
  if [[ "$(git remote get-url origin)" != "$expected_remote" ]]; then
    printf 'The origin remote does not match %s. Review it before publishing.\n' "$expected_remote" >&2
    exit 1
  fi
elif gh repo view "$repo" --json name >/dev/null 2>&1; then
  printf 'The remote repository exists, but this checkout is not connected to it. Review it before publishing.\n' >&2
  exit 1
fi

# Stage only the website and its documentation, never arbitrary workspace files.
files=(index.html styles.css 404.html assets/favicon.svg assets/painted-room.svg .nojekyll .gitignore README.md publish.sh)
if ! git diff --cached --quiet; then
  printf 'Commit or unstage existing staged changes before running this script.\n' >&2
  exit 1
fi
git add -- "${files[@]}"
if ! git diff --cached --quiet; then
  git -c user.name="Abdullah Zubair" -c user.email="79211374+a6zubair@users.noreply.github.com" \
    commit -m "Build Sparkling Shine painting website"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$repo" --public \
    --description "Residential and home painting by Sparkling Shine. Contact Zubair Khalil for an email quotation."
  git remote add origin "$expected_remote"
fi

# Use the existing gh login without changing global Git credential settings.
git -c credential.helper= -c 'credential.https://github.com.helper=!gh auth git-credential' push -u origin main

pages_payload='{"build_type":"legacy","source":{"branch":"main","path":"/"}}'
if gh api "repos/$repo/pages" >/dev/null 2>&1; then
  gh api --method PUT "repos/$repo/pages" --input - <<< "$pages_payload" >/dev/null
else
  gh api --method POST "repos/$repo/pages" --input - <<< "$pages_payload" >/dev/null
fi

printf '\nGitHub Pages is configured. Waiting for the initial build...\n'
for attempt in {1..24}; do
  status="$(gh api "repos/$repo/pages" --jq '.status // "pending"')"
  if [[ "$status" == "built" ]]; then
    site_url="$(gh api "repos/$repo/pages" --jq .html_url)"
    printf '\nPublished: %s\nRepository: https://github.com/%s\n' "$site_url" "$repo"
    exit 0
  fi
  if [[ "$status" == "errored" ]]; then
    printf 'The Pages build failed. See https://github.com/%s/actions\n' "$repo" >&2
    exit 1
  fi
  sleep 10
done

printf '\nFiles are pushed and Pages is configured; the build is still pending.\n'
printf 'Check deployment: https://github.com/%s/actions\n' "$repo"
printf 'Expected website URL after deployment: https://%s.github.io/sparkling-shine/\n' "$owner"
