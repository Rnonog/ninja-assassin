# dev-workflow

**Typ:** Feature
**Status:** erledigt
**Worktree:** `task/dev-workflow` (Pfad `.worktrees/dev-workflow`)

## Ziel

Den Entwicklungsprozess (Plan → Slices → Implementierung → Review → Playtest) als Cursor-Regeln, Subagents, Skills und Plan-Templates hinterlegen. Kein Spielcode.

## Metrik

Script `scripts/check-dev-workflow.sh` ist grün: beide Regeln, sechs Agents, acht Skills, drei Templates, README und dieser Ordner existieren.

## Scope

- `.cursor/rules/dev-workflow.mdc`, `git-trunk.mdc`
- `.cursor/agents/` (sechs Subagents inkl. `bug-investigator`)
- `.cursor/skills/` (Orchestration + Git + eine Skill-Datei pro Subagent)
- `docs/plans/_templates/` und dieser Slice
- `.gitignore` mit `.worktrees/`
- Existenz-Check-Script

## Out of scope

- Godot-/Gameplay-Code
- GitLab / Branch `master`
- `spiel-playtester` in diesem Slice (kein laufendes Spiel)

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-prozess-hinterlegen.md` | Prozess hinterlegen | erledigt |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
