# mvp-boss

**Typ:** Feature
**Status:** in Umsetzung
**Worktree:** `task/mvp-boss` (Pfad `.worktrees/mvp-boss`)

## Ziel

Klan-Schläger-Hauptmann in der Arena: Arena schließt sich, Boss-HP-Balken, Sieg (Boss tot + Ausgang) und Niederlage (Respawn). Zweiter Schrein vor der Arena.

## Metrik

`bash scripts/run-tests.sh` grün; Arena-Lock, Stampf, Sieg nur nach Boss-Tod plus Exit; Tod mit lebendem Boss setzt Arena zurück.

## Scope

- `clan_captain.gd` / `clan_captain.tscn` (Stampf, Telegraph, Pause)
- `arena_controller.gd`: Lock, Wände, Reset, Exit-Sieg
- Zweiter Schrein; `RunSession` hört alle Checkpoints
- Boss-HP-Balken (CanvasLayer, nur im Kampf)
- Sieg-/Niederlage-Overlay
- `Health.BOSS_MAX_HP`, `BOSS_STOMP_DAMAGE`

## Out of scope

- Intro-Cutscene
- Pause-Menü
- Spieler-HUD Canvas
- Pixel-Art, Audio, Web-Export
- `JUMP_*` / Dodge / Combo retune

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-boss-arena.md` | Hauptmann, Arena, Sieg/Niederlage | implementiert |
| `02-intro-pause.md` | Intro-Silhouette, Pause Esc | Stub / offen |

## Fortschritt (MVP-Stufen)

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | `docs/plans/mvp-nahkampf/` | erledigt |
| 3 | Fernkampf & Gegner | `docs/plans/mvp-fernkampf/` | erledigt |
| 4 | Level Nebliger Wald | `docs/plans/mvp-wald/` | erledigt |
| 5 | Boss, Sieg, Intro | `docs/plans/mvp-boss/` | in Umsetzung |
| 6 | Atmosphäre, HUD, Export | — | offen |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
