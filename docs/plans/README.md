# Pläne

Jeder Task (Feature, Bug, Verbesserung) hat einen Ordner `docs/plans/<aufgabe>/`.

## Ablauf

1. Subagent `task-slicer` erzeugt `INDEX.md` und Stubs aus `_templates/`.
2. Features: Subagent `feature-planner` füllt die Slice-Dateien. Bugs: `bug-investigator` füllt `BUG.md` (Phase 0).
3. User gibt im INDEX frei.
4. `feature-implementer` → Parent startet `code-reviewer` mit `run_in_background: true` (Plan so umgesetzt wie gewollt, Struktur, Modularisierung, Best Practices) → Criticals fixen. Merge-Gate ist headless (`bash scripts/run-tests.sh`). Visuelles Playtest (`spiel-playtester`) nur auf ausdrücklichen Wunsch, dann ebenfalls `run_in_background`; sonst Skip mit Grund.

Kleine Aufgaben: ein Slice reicht.

Mehrphasige Vorhaben: Fortschrittstabelle im übergeordneten Plan (`offen` / `in Umsetzung` / `erledigt`). Nach abgeschlossener Phase (headless-Tests, Review, Push; visuelles Playtest nur auf Wunsch) markieren, bevor die nächste startet.

Orchestration: Skill `dev-workflow`. Git: Skill `git-trunk` und Regel `.cursor/rules/git-trunk.mdc`.

## Dateien

| Datei | Zweck |
|-------|--------|
| `_templates/INDEX.md` | Ziel, Metrik, Scope, Slice-Liste, Worktree, Freigabe |
| `_templates/SLICE.md` | Feature-/Verbesserungs-Slice |
| `_templates/BUG.md` | Bug Phase 0 + Fix/Retest |
