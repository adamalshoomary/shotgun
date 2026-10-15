#!/bin/sh
# Installs the shotgun skill for every coding agent on this computer that reads Agent Skills.
#
#   curl -fsSL https://github.com/adamalshoomary/shotgun/releases/latest/download/install.sh | sh
#   sh shotgun/install.sh      from a clone: installs the copy in that clone
#
# The skill needs its whole folder: SKILL.md, VERSION, four guides and templates/.
# Claude Code reads ~/.claude/skills. Codex, Gemini CLI, Cursor and most other agents read ~/.agents/skills.
# A release holds its files flat. SHOTGUN_FROM sets another address for them; CI uses it to test a build.
# Keep FILES and TEMPLATES in step with install.ps1 and tools/release_files.py.
set -e

FROM="${SHOTGUN_FROM:-https://github.com/adamalshoomary/shotgun/releases/latest/download}"
FILES="SKILL.md VERSION SETUP.md CONTINUE.md WORKFLOW.md MIGRATIONS.md"
# A release cannot hold a file whose name starts with a dot, so .gitignore.template travels as gitignore.template.
TEMPLATES="AGENTS.md.template current-state.md.template improvement-plan.md.template project-purpose.md.template gitignore.template"
SRC=""
TMP=""

# "$0" names a file only when this script runs from a file. Piped from curl, it downloads.
HERE="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"
if [ -z "$SHOTGUN_FROM" ] && [ -f "$0" ] && [ -f "$HERE/skills/shotgun/SKILL.md" ]; then
  SRC="$HERE/skills/shotgun"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  mkdir -p "$TMP/templates"
  for F in $FILES; do
    curl -fsSL "$FROM/$F" -o "$TMP/$F" || {
      echo "shotgun: could not download $F from $FROM. Try again, or install with: npx skills add adamalshoomary/shotgun -g" >&2
      exit 1
    }
  done
  for F in $TEMPLATES; do
    OUT="$F"
    [ "$F" = "gitignore.template" ] && OUT=".gitignore.template"
    curl -fsSL "$FROM/$F" -o "$TMP/templates/$OUT" || {
      echo "shotgun: could not download $F from $FROM. Try again, or install with: npx skills add adamalshoomary/shotgun -g" >&2
      exit 1
    }
  done
  SRC="$TMP"
fi

if [ ! -s "$SRC/SKILL.md" ] || [ ! -s "$SRC/templates/AGENTS.md.template" ]; then
  echo "shotgun: the download did not contain the skill. Try again, or install with: npx skills add adamalshoomary/shotgun -g" >&2
  exit 1
fi

# Versions before 4.0.0 installed as "handoff". Remove that copy only when it is shotgun's own.
for OLD in "$HOME/.claude/skills/handoff" "$HOME/.agents/skills/handoff"; do
  if [ -f "$OLD/SKILL.md" ] && grep -q "shotgun" "$OLD/SKILL.md" && grep -q "^name: handoff" "$OLD/SKILL.md"; then
    rm -rf "$OLD"
    echo "removed the old handoff skill: $OLD"
  fi
done

for DEST in "$HOME/.claude/skills/shotgun" "$HOME/.agents/skills/shotgun"; do
  rm -rf "$DEST"
  mkdir -p "$DEST/templates"
  for F in $FILES; do cp "$SRC/$F" "$DEST/"; done
  cp "$SRC"/templates/*.template "$SRC/templates/.gitignore.template" "$DEST/templates/"
  echo "installed: $DEST"
done

echo "shotgun $(cut -d' ' -f1 "$SRC/VERSION") is ready. Restart your agent, open your project folder and run: /shotgun setup"
