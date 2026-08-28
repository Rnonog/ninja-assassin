# Pläne

Jeder Task (Feature, Bug, Verbesserung) hat einen Ordner `docs/plans/<aufgabe>/`.

## Ablauf

1. Subagent `task-slicer` erzeugt `INDEX.md` und Stubs aus `_templates/`.
2. Features: Subagent `feature-planner` füllt die Slice-Dateien. Bugs: `bug-investigator` füllt `BUG.md` (Phase 0).
3. User gibt im INDEX frei.
4. `feature-implementer` → `code-reviewer` (Plan so umgesetzt wie gewollt, Struktur, Modularisierung, Best Practices) → Criticals fixen → `spiel-playtester`.

Kleine Aufgaben: ein Slice reicht.

Mehrphasige Vorhaben: Fortschrittstabelle im übergeordneten Plan (`offen` / `in Umsetzung` / `erledigt`). Nach abgeschlossener Phase (Playtest + Push) markieren, bevor die nächste startet.

Orchestration: Skill `dev-workflow`. Git: Skill `git-trunk` und Regel `.cursor/rules/git-trunk.mdc`.

## Dateien

| Datei | Zweck |
|-------|--------|
| `_templates/INDEX.md` | Ziel, Metrik, Scope, Slice-Liste, Worktree, Freigabe |
| `_templates/SLICE.md` | Feature-/Verbesserungs-Slice |
| `_templates/BUG.md` | Bug Phase 0 + Fix/Retest |
