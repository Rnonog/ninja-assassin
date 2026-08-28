# mvp-nahkampf

**Typ:** Feature
**Status:** erledigt
**Worktree:** `task/mvp-nahkampf` (Pfad `.worktrees/mvp-nahkampf`)

## Ziel

Spieler kann mit Katana (leicht/schwer) treffen und bei 0 HP sterben.

## Metrik

`bash scripts/godot.sh --headless --path . -s tests/run_tests.gd` ist grün; J/K unterscheidbar; Tod bei 0 HP; Dummy telegraphiert Schlag.

## Scope

- J leichter / K schwerer Katana-Hieb mit eigenen Hitboxes, Dauer, Schaden
- Dummy auf Greybox: Hurtbox, telegraphierter Schlag in Schleife; Dodge-i-Frames gelten
- Spieler 100 HP, kein Regen; Tod bei 0 HP (Input aus, Szene nach ~2 s neu)
- Minimales Treffer-Feedback: Freeze-Frame bei Hit plus Hurt-Flash
- Combokette L→L→H ist Stretch, kein Blocker
- Kleines Greybox-HP-Label am Spieler (kein HUD Stufe 6)

## Out of scope

- Wurfsterne
- Echte Gegner-KI
- Heilung
- Checkpoints
- Luft-Angriff
- Block
- Pixel-Art
- HUD
- Web-Export
- Level Nebliger Wald

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-katana-hp-dummy.md` | Katana, HP, Dummy | erledigt |

## Fortschritt (MVP-Stufen)

Übergeordnet: KONZEPT.md §12.1. Diese Aufgabe ist Stufe 2. Parent muss KONZEPT-Roadmap / Cursor-Plan / Canvas synchron halten.

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | `docs/plans/mvp-nahkampf/` | erledigt |
| 3 | Fernkampf & Gegner | — | offen |
| 4 | Level Nebliger Wald | — | offen |
| 5 | Boss, Sieg, Intro | — | offen |
| 6 | Atmosphäre, HUD, Export | — | offen |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
