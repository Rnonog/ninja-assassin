# Slice: Prozess hinterlegen

**Aufgabe:** `docs/plans/dev-workflow/`
**Status:** erledigt

## Ziel

Regeln, Skills, Subagents und Plan-Templates liegen im Repo, damit Folgeaufgaben dem Prozess folgen.

## Akzeptanzkriterien

- [x] `.cursor/rules/dev-workflow.mdc` und `git-trunk.mdc` mit `alwaysApply: true`
- [x] Sechs Subagents unter `.cursor/agents/`
- [x] Skills unter `.cursor/skills/` (dev-workflow, git-trunk, plus eine je Subagent)
- [x] Templates `INDEX.md`, `SLICE.md`, `BUG.md`
- [x] `scripts/check-dev-workflow.sh` ist grün
- [x] In-Game-Checks begründet übersprungen

## Automatisierte Tests

- Script `scripts/check-dev-workflow.sh` prüft, dass die Pflicht-Dateien existieren.
- Befehl: `bash scripts/check-dev-workflow.sh`

## In-Game-Checks

- [x] Übersprungen, weil: kein Spielcode in diesem Slice (nur Prozess-Dateien)

## Out of scope

- Godot-Projekt, Bewegung, Kampf
- Force-Push, GitLab-Remote

## Notizen für den Implementer

- Bootstrap: Parent legt Dateien an, danach einmal `code-reviewer`.
- Push-Ziel: GitHub `origin/main` nach Rebase.
