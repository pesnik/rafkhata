#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MESSAGE="${*:-Deploy site}"

NODE8_BIN="${NODE8_BIN:-$HOME/.local/share/fnm/node-versions/v8.17.0/installation/bin}"
if [ -x "$NODE8_BIN/node" ]; then
  export PATH="$NODE8_BIN:$PATH"
fi
case "$(node -v)" in
  v8.*) ;;
  *)
    echo "gulp 3 needs Node 8. Set NODE8_BIN to its bin directory." >&2
    exit 1
    ;;
esac

npx gulp build

git fetch origin gh-pages
WT="$(mktemp -d "${TMPDIR:-/tmp}/rafkhata-pages.XXXXXX")"
cleanup() {
  cd "$ROOT"
  git worktree remove --force "$WT" >/dev/null 2>&1 || true
  git worktree prune
}
trap cleanup EXIT

git worktree add --detach "$WT" origin/gh-pages >/dev/null
cd "$WT"
git rm -rf . >/dev/null

rsync -a --exclude 'fonts/' --exclude '.DS_Store' "$ROOT/build/" "$WT"/
rm -f app.appcache
perl -pi -e 's/ manifest="app\.appcache"//' index.html
perl -0pi -e "s/\@font-face\{font-family:Rafkhata;src:url\(\.\.\/fonts\/LiSubha[^}]*\}//g" css/app-*.css

cat > wrangler.jsonc <<'JSON'
{
  "name": "rafkhata",
  "compatibility_date": "2026-10-19",
  "assets": {
    "directory": "./"
  }
}
JSON

cat > .assetsignore <<'IGNORE'
.git
.wrangler
.DS_Store
.nojekyll
wrangler.jsonc
.assetsignore
IGNORE

touch .nojekyll
git add -A
if git diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

git commit -m "$MESSAGE" >/dev/null
git push origin HEAD:gh-pages

echo "Deployed: https://pesnik.github.io/rafkhata/"
