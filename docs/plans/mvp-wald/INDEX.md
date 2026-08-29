# mvp-wald

**Typ:** Feature
**Status:** erledigt
**Worktree:** `task/mvp-wald` (Pfad `.worktrees/mvp-wald`)

## Ziel

Links-nach-rechts Level (Hafen-Tiles gestreckt): Einstieg Dummy → Kampfzone 1 → Schrein → Plattform+Grube → Kampfzone 2 → Heal/Ammo → leere Arena → Ausgang. Ein Checkpoint, Respawn statt Scene-Reload.

## Metrik

`bash scripts/run-tests.sh` grün; Schrein speichert Munition; Tod/Fall respawnt am letzten Checkpoint mit `MAX_HP` und gespeicherter Munition; Kampfzonen haben freien Bodenweg.

## Scope

- Keep harbor tiles/parallax, stretch layout
- Dummy stays ~x=300 punching bag
- Zone 1: 1 thug + 1 thrower + 1 ammo
- One shrine checkpoint auto-activate ColorRect
- Platform section 2-3 crates over kill-plane pit; `JUMP_VELOCITY` unchanged
- Zone 2: 2 thugs + 1 thrower
- Supply: 1 heal + 1 ammo before empty arena + exit marker
- `scripts/checkpoint.gd` + `scenes/checkpoint.tscn`
- `scripts/run_session.gd` on Main
- `scripts/kill_plane.gd`
- `player.respawn(position, ammo)`; `Health.restore_full()` optional
- Dead enemies stay dead; collected pickups stay gone
- Combat zones must not be blocked by platforms (no Platform1 at x≈232 on the walking path)

## Out of scope

- Boss
- Arena close
- Intro
- Forest pixel art
- Fog particles
- HUD canvas
- Trapper
- Axe fighter
- Waterfall
- JUMP/dodge/combo retune
- Dummy death/removal
- Web export

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-level-checkpoint.md` | Zonen, Schrein, Respawn | implementiert |

## Fortschritt (MVP-Stufen)

Übergeordnet: KONZEPT.md §12.1. Diese Aufgabe ist Stufe 4. Parent muss KONZEPT-Roadmap / Cursor-Plan / Canvas synchron halten.

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | `docs/plans/mvp-nahkampf/` | erledigt |
| 3 | Fernkampf & Gegner | `docs/plans/mvp-fernkampf/` | erledigt |
| 4 | Level Nebliger Wald | `docs/plans/mvp-wald/` | erledigt |
| 5 | Boss, Sieg, Intro | — | offen |
| 6 | Atmosphäre, HUD, Export | — | offen |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
