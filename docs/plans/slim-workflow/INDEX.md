# slim-workflow

**Typ:** Verbesserung
**Status:** erledigt
**Worktree:** `task/slim-workflow`

## Ziel

Rollen-Skills entfernen, die die Subagents 1:1 duplizierten. Orchestration und Git bleiben Skills.

## Metrik

`scripts/check-dev-workflow.sh` ist grün: sechs Rollen-Skills fehlen, `dev-workflow` und `git-trunk` existieren, Agents verweisen nicht auf gelöschte Skill-Pfade.

## Scope

- Sechs Rollen-Skills löschen
- Agents selbsttragend
- Check-Script und README anpassen

## Out of scope

- Subagents zusammenlegen
- Godot-/Gameplay-Code

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-rollen-skills-entfernen.md` | Rollen-Skills entfernen | erledigt |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
