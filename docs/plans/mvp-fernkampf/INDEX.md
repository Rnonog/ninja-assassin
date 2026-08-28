# mvp-fernkampf

**Typ:** Feature
**Status:** erledigt
**Worktree:** `task/mvp-fernkampf` (Pfad `.worktrees/mvp-fernkampf`)

## Ziel

Spieler wirft Wurfsterne mit begrenzter Munition; Pickups für Munition und Heilung (+30); Klan-Schläger rennt zu und sticht; Wurfkämpfer hält Abstand und wirft nach Telegraph. Dummy aus Stufe 2 bleibt.

## Metrik

`bash scripts/godot.sh --headless --path . -s tests/run_tests.gd` ist grün; Munition begrenzt; beide Gegner-Muster lesbar; Nahkampf stärker als Fernkampf.

## Scope

- L throw, facing, no throw during dodge / heavy windup+active
- `SHURIKEN_DAMAGE` 6, `START_AMMO` 5, `PICKUP` 3, `MAX` 10, `SPEED` ~420
- `HEAL_PICKUP` 30, cap `MAX_HP`
- ColorRect placeholders only
- `scripts/projectile.gd` + `scenes/shuriken.tscn`
- `scripts/pickup.gd` + `ammo_pickup.tscn` / `heal_pickup.tscn`
- `scripts/clan_thug.gd` + `clan_thug.tscn`
- `scripts/throw_fighter.gd` + `throw_fighter.tscn`
- player `request_throw`, `shuriken_ammo`, ammo label, `heal()`
- `main.tscn`: dummy stays ~x=300; thug and thrower further right; 1 ammo + 1 heal pickup
- new physics layers: `enemy`, `enemy_hitbox`, `player_projectile`, `enemy_projectile`
- `THUG_DAMAGE` 15, `THROWER_DAMAGE` 10, HP 40/30, enemies die at 0 HP
- shuriken interrupt thrower telegraph

## Out of scope

- Pixel art for new elements
- Smoke bomb
- Trapper
- Boss
- Checkpoint
- HUD canvas
- Web export
- JUMP/dodge numbers
- Combo changes
- Remove dummy

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-wurfstern-gegner.md` | Wurfstern, Pickups, Schläger, Wurfkämpfer | implementiert |

## Fortschritt (MVP-Stufen)

Übergeordnet: KONZEPT.md §12.1. Diese Aufgabe ist Stufe 3. Parent muss KONZEPT-Roadmap / Cursor-Plan / Canvas synchron halten.

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | `docs/plans/mvp-nahkampf/` | erledigt |
| 3 | Fernkampf & Gegner | `docs/plans/mvp-fernkampf/` | erledigt |
| 4 | Level Nebliger Wald | — | offen |
| 5 | Boss, Sieg, Intro | — | offen |
| 6 | Atmosphäre, HUD, Export | — | offen |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
