#!/usr/bin/env sh
# Publish the rendered analysis reports to GitHub Pages (gh-pages branch).
# Usage: scripts/publish-pages.sh   (run from the repo root after `quarto render` in analysis/)
set -eu
root=$(git rev-parse --show-toplevel)
pages="$root/../arbiter-JAMIA-pages"
[ -d "$pages" ] || git -C "$root" worktree add "$pages" gh-pages
cp "$root/analysis/results.html" "$root/analysis/supplement.html" "$pages/"
cd "$pages"
git add -A
git diff --cached --quiet && { echo "Pages already up to date."; exit 0; }
git commit -qm "Publish analysis reports from $(git -C "$root" rev-parse --short HEAD)"
git push -q origin gh-pages
echo "Published: https://alisalman-et-al.github.io/arbiter-JAMIA/"
