#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
missing=0

check() {
  local rel="$1"
  if [[ ! -f "$root/$rel" ]]; then
    echo "MISSING: $rel"
    missing=1
  else
    echo "OK: $rel"
  fi
}

echo "=== Regeln ==="
check ".cursor/rules/dev-workflow.mdc"
check ".cursor/rules/git-trunk.mdc"

echo "=== Subagents ==="
check ".cursor/agents/task-slicer.md"
check ".cursor/agents/feature-planner.md"
check ".cursor/agents/bug-investigator.md"
check ".cursor/agents/feature-implementer.md"
check ".cursor/agents/code-reviewer.md"
check ".cursor/agents/spiel-playtester.md"

echo "=== Skills ==="
check ".cursor/skills/dev-workflow/SKILL.md"
check ".cursor/skills/git-trunk/SKILL.md"
check ".cursor/skills/task-slicer/SKILL.md"
check ".cursor/skills/feature-planner/SKILL.md"
check ".cursor/skills/bug-investigator/SKILL.md"
check ".cursor/skills/feature-implementer/SKILL.md"
check ".cursor/skills/code-reviewer/SKILL.md"
check ".cursor/skills/spiel-playtester/SKILL.md"

echo "=== Plan-Templates ==="
check "docs/plans/README.md"
check "docs/plans/_templates/INDEX.md"
check "docs/plans/_templates/SLICE.md"
check "docs/plans/_templates/BUG.md"
check "docs/plans/dev-workflow/INDEX.md"
check "docs/plans/dev-workflow/01-prozess-hinterlegen.md"

echo "=== Sonstiges ==="
check ".gitignore"

echo "=== alwaysApply ==="
for rel in ".cursor/rules/dev-workflow.mdc" ".cursor/rules/git-trunk.mdc"; do
  if grep -q 'alwaysApply: true' "$root/$rel"; then
    echo "OK: $rel has alwaysApply: true"
  else
    echo "MISSING FLAG: $rel alwaysApply: true"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "FAIL: fehlende Dateien"
  exit 1
fi

echo "PASS: alle Pflicht-Dateien vorhanden"
