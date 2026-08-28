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

echo "=== Skills (nur Orchestration + Git) ==="
check ".cursor/skills/dev-workflow/SKILL.md"
check ".cursor/skills/git-trunk/SKILL.md"

echo "=== Keine Rollen-Skills ==="
for rel in \
  ".cursor/skills/task-slicer/SKILL.md" \
  ".cursor/skills/feature-planner/SKILL.md" \
  ".cursor/skills/bug-investigator/SKILL.md" \
  ".cursor/skills/feature-implementer/SKILL.md" \
  ".cursor/skills/code-reviewer/SKILL.md" \
  ".cursor/skills/spiel-playtester/SKILL.md"
do
  if [[ -e "$root/$rel" ]]; then
    echo "UNEXPECTED: $rel"
    missing=1
  else
    echo "OK: absent $rel"
  fi
done

echo "=== Plan-Templates ==="
check "docs/plans/README.md"
check "docs/plans/_templates/INDEX.md"
check "docs/plans/_templates/SLICE.md"
check "docs/plans/_templates/BUG.md"
check "docs/plans/dev-workflow/INDEX.md"
check "docs/plans/dev-workflow/01-prozess-hinterlegen.md"
check "docs/plans/slim-workflow/INDEX.md"
check "docs/plans/slim-workflow/01-rollen-skills-entfernen.md"
check "docs/plans/async-tests/INDEX.md"
check "docs/plans/async-tests/01-headless-background.md"

echo "=== Sonstiges ==="
check ".gitignore"

echo "=== Agents ohne gelöschte Skill-Pfade ==="
if grep -R -E 'skills/(task-slicer|feature-planner|bug-investigator|feature-implementer|code-reviewer|spiel-playtester)/' "$root/.cursor/agents" --include='*.md'; then
  echo "UNEXPECTED: Agent verweist auf gelöschte Rollen-Skill"
  missing=1
else
  echo "OK: keine Rollen-Skill-Pfade in .cursor/agents/"
fi

echo "=== Skills-Ordner nur Orchestration + Git ==="
skill_dirs="$(find "$root/.cursor/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tr '\n' ' ')"
if [[ "$skill_dirs" != "dev-workflow git-trunk " ]]; then
  echo "UNEXPECTED skill dirs: $skill_dirs"
  missing=1
else
  echo "OK: nur dev-workflow und git-trunk"
fi

echo "=== Mehrphasiger Fortschritt ==="
if grep -qi 'mehrphasig' "$root/.cursor/skills/dev-workflow/SKILL.md" \
  && grep -qi 'mehrphasig' "$root/.cursor/rules/dev-workflow.mdc"; then
  echo "OK: mehrphasiger Fortschritt in Skill und Regel"
else
  echo "MISSING: mehrphasiger Fortschritt in Skill oder Regel"
  missing=1
fi

echo "=== Headless-Suite und Background-Review ==="
skill="$root/.cursor/skills/dev-workflow/SKILL.md"
rule="$root/.cursor/rules/dev-workflow.mdc"
playtester="$root/.cursor/agents/spiel-playtester.md"
if grep -qE 'run_in_background|Hintergrund' "$skill" \
  && grep -qi 'headless' "$skill" \
  && grep -qE 'run_in_background|Hintergrund' "$rule" \
  && grep -qi 'headless' "$rule"; then
  echo "OK: Skill und Regel erwähnen run_in_background/Hintergrund und headless"
else
  echo "MISSING: Skill oder Regel ohne run_in_background/Hintergrund oder headless"
  missing=1
fi
if grep -qi 'windowed' "$playtester" \
  && grep -qi 'explicit' "$playtester" \
  && grep -qi 'headless' "$playtester" \
  && grep -qi 'focus' "$playtester"; then
  echo "OK: spiel-playtester.md enthält die neue Policy (windowed/explicit/headless/focus)"
else
  echo "MISSING: spiel-playtester.md Policy (windowed, explicit, headless, focus)"
  missing=1
fi

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
  echo "FAIL: fehlende oder überzählige Dateien"
  exit 1
fi

echo "PASS: alle Pflicht-Dateien vorhanden"
