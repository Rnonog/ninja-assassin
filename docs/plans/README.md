# Pläne

Jeder Task (Feature, Bug, Verbesserung) hat einen Ordner `docs/plans/<aufgabe>/`.

## Ablauf

1. Subagent `task-slicer` erzeugt `INDEX.md` und Stubs aus `_templates/`.
2. Features: Subagent `feature-planner` füllt die Slice-Dateien. Bugs: `bug-investigator` füllt `BUG.md` (Phase 0).
3. User gibt im INDEX frei.
4. `feature-implementer` → `code-reviewer` → Criticals fixen → `spiel-playtester`.

Kleine Aufgaben: ein Slice reicht.

## Dateien

| Datei | Zweck |
|-------|--------|
| `_templates/INDEX.md` | Ziel, Metrik, Scope, Slice-Liste, Worktree, Freigabe |
| `_templates/SLICE.md` | Feature-/Verbesserungs-Slice |
| `_templates/BUG.md` | Bug Phase 0 + Fix/Retest |

Worktree, Rebase und Push: Skill `git-trunk`, Regel `.cursor/rules/git-trunk.mdc`.
