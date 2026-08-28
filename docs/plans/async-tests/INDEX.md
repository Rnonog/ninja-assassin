# async-tests

**Typ:** Verbesserung
**Status:** freigegeben
**Worktree:** `task/async-tests` (Pfad `.worktrees/async-tests`)

## Ziel

Review und automatisierte Tests blockieren weder Chat noch Bildschirm. Die Headless-Suite bleibt Pflicht-Gate. Visuelles Playtest (Godot-Fenster) nur wenn der User es ausdrücklich will.

## Metrik

`scripts/check-dev-workflow.sh` ist grün und prüft die neuen Pflicht-Texte; `spiel-playtester` startet kein Fenster; Parent startet Reviewer/Playtester im Hintergrund (`run_in_background`).

## Scope

- `.cursor/rules/dev-workflow.mdc`
- `.cursor/skills/dev-workflow/SKILL.md`
- `.cursor/agents/spiel-playtester.md`
- `.cursor/agents/feature-implementer.md`
- `docs/plans/README.md`
- `docs/plans/_templates/SLICE.md`
- `docs/plans/_templates/BUG.md`
- `scripts/check-dev-workflow.sh`

## Out of scope

- Godot-/Gameplay-Code
- Physik-Tests umschreiben
- Subagents zusammenlegen
- git-trunk ändern
- visuelles Playtest zur Pflicht machen

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-headless-background.md` | Headless-Suite und Background-Review | implementiert |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
