# code-reviewer-plan

**Typ:** Verbesserung
**Status:** erledigt
**Worktree:** `task/code-reviewer-plan`

## Ziel

Der Subagent `code-reviewer` prüft, ob der freigegebene Slice so umgesetzt wurde wie gewollt, und ob Codestruktur, Modularisierung und Best Practices stimmen.

## Metrik

`.cursor/agents/code-reviewer.md` nennt Plan-Treue, Struktur, Modularisierung und Best Practices als Pflicht. Regeln und Orchestration-Skill verweisen darauf.

## Scope

- `.cursor/agents/code-reviewer.md`
- Kurze Verweise in Regel, Skill `dev-workflow`, `docs/plans/README.md`

## Out of scope

- Godot-/Gameplay-Code
- Weitere Subagents umbauen

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-reviewer-plan-struktur.md` | Reviewer auf Plan und Struktur | erledigt |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
