# mvp-steuerung

**Typ:** Feature
**Status:** erledigt
**Worktree:** `task/mvp-steuerung` (Pfad `.worktrees/mvp-steuerung`)

## Ziel

Spieler kann laufen, springen und ausweichen auf einer Greybox-Teststrecke. Godot-4-Projekt startet ohne Fehler.

## Metrik

`bash scripts/godot.sh --headless --path . -s tests/run_tests.gd` ist grün; Szene startet; Steuerung fühlt sich unmittelbar an.

## Scope

- Godot 4.7.2 Projekt im Repo-Root (`project.godot`, Szenen Main/Player/Level)
- Input Map laut KONZEPT §8.1 (A/D, Leertaste, Shift, J/K/L, Esc)
- CharacterBody2D: Gravitation, Laufen, Einfachsprung, Ausweichen mit i-Frames; Kamera folgt
- Coyote-Time + Jump-Buffer (80–120 ms); variable Sprunghöhe (Leertaste loslassen kürzt Aufstieg) — User-bestätigt
- Greybox-Boden und Plattformen — keine Pixel-Art
- Headless-Tests + Wrapper-Scripts für Godot-Binary (`tools/`, gitignored)

## Out of scope

- Kampf
- HP
- Gegner
- Doppelsprung
- Wandsprung
- Klettern
- Gamepad
- Rauchbombe
- Pixel-Art
- HUD
- Web-Export
- Level Nebliger Wald

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-godot-player-greybox.md` | Godot, Player, Greybox | erledigt |

## Fortschritt (MVP-Stufen)

Übergeordnet: KONZEPT.md §12.1. Diese Aufgabe ist Stufe 1.

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | `docs/plans/mvp-nahkampf/` | erledigt |
| 3 | Fernkampf & Gegner | — | offen |
| 4 | Level Nebliger Wald | — | offen |
| 5 | Boss, Sieg, Intro | — | offen |
| 6 | Atmosphäre, HUD, Export | — | offen |

Stufe 1: Headless-Tests, Review, Playtest und Push abgeschlossen.

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
