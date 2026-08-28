# Slice: Rollen-Skills entfernen

**Aufgabe:** `docs/plans/slim-workflow/`
**Status:** erledigt

## Ziel

Nur noch zwei Skills: `dev-workflow` (Orchestration) und `git-trunk` (Git). Die sechs Rollen leben ausschließlich als Subagents.

## Akzeptanzkriterien

- [x] Keine `SKILL.md` unter `.cursor/skills/{task-slicer,feature-planner,bug-investigator,feature-implementer,code-reviewer,spiel-playtester}/`
- [x] Sechs Agents ohne Verweis auf gelöschte Skill-Pfade
- [x] Skills `dev-workflow` und `git-trunk` bleiben
- [x] `scripts/check-dev-workflow.sh` ist grün
- [x] In-Game-Checks begründet übersprungen

## Automatisierte Tests

- `bash scripts/check-dev-workflow.sh`

## In-Game-Checks

- [x] Übersprungen, weil: kein Spielcode

## Out of scope

- `task-slicer` und `feature-planner` zusammenlegen
