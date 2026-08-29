# Slice: Outline und Idle-Farben

**Aufgabe:** `docs/plans/enemy-contrast/`
**Status:** implementiert
**Slice-ID:** `01-placeholder-contrast`

## Ziel

Dummy, Schläger und Wurfkämpfer mit hellem Umriss und saturierten Idle-Farben gegen die Hafen-Nacht lesbar; Typen auf einen Blick unterscheidbar. Keine Gameplay-Änderung.

## Akzeptanzkriterien

- [x] **Outline:** In `scenes/dummy.tscn`, `scenes/clan_thug.tscn`, `scenes/throw_fighter.tscn` ein `Outline`-ColorRect, im Tree **vor** `Body`, ~`OUTLINE_GROW` px größer, Farbe `COLOR_OUTLINE`.
- [x] **Idle-Farben** nur in den Scripts, `.tscn` Body/Band gleich:
  - Dummy: warmes Holz (`Dummy.COLOR_IDLE`)
  - Schläger: warmes Rot/Orange (`ClanThug.COLOR_IDLE`)
  - Wurfkämpfer: Cyan/Stahl (`ThrowFighter.COLOR_IDLE`)
- [x] Idle-Luminanz (0.2126R+0.7152G+0.0722B) ≥ `Dummy.MIN_IDLE_LUMINANCE` für alle drei `COLOR_IDLE`.
- [x] Paarweiser RGB-Abstand der drei Idle-Farben ≥ `Dummy.MIN_IDLE_COLOR_DISTANCE`.
- [x] Telegraph/Swipe/Throw-Farben unverändert. Collision 24×40 unverändert.
- [x] Kein ColorRect in `level_greybox.tscn`. Keine neuen Sprites.
- [x] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

## Automatisierte Tests

Headless-Pflicht (Merge-Gate, `scripts/run-tests.sh`, kein Fenster):

- Idle-Luminanz und paarweiser Abstand aus Script-Konstanten (keine Magic Numbers für Farben)
- Szenen: `Outline` existiert, größer als `Body`, Body-Farbe = jeweiliges `COLOR_IDLE`
- Collision-Shape der drei Szenen bleibt `PLAYER_COLLISION_SIZE` / 24×40
- Bestehende Suite Stufe 1–4 bleibt grün

Befehl: `bash scripts/run-tests.sh`

## In-Game-Checks

Visuelle In-Game-Checks nur auf ausdrücklichen User-Wunsch; sonst überspringen mit Begründung. Default ist die headless-Suite, kein Fensterspiel.

- Dummy, Schläger, Wurfkämpfer vom Pier getrennt und farblich unterscheidbar
- [x] Übersprungen, weil: kein ausdrücklicher User-Wunsch nach visuellem Playtest — Default ist headless, kein Godot-Editor, kein Fensterspiel, kein Fokus-Diebstahl.

### Playtest-Ergebnis (spiel-playtester)

- **Headless:** `bash scripts/run-tests.sh` — **74 passed, 0 failed**. Merge-Gate grün. Suite nicht erneut gestartet (bereits gemeldet).
- **Visuell:** SKIPPED — user did not request visual playtest. No windowed Godot, no Godot editor, no focus steal.
- **Merge-Blocker durch Playtest:** keiner. Visual-Skip blockiert Merge nicht (Default laut Workflow).

## Out of scope

- Pixel-Art (Stufe 6)
- KI / Schaden / Hitbox-Retune
- Checkpoint- und Pickup-Visuals
- ColorRects im Level-Greybox

## Notizen für den Implementer

- `_apply_body_color()` überschreibt `Body` jede Physik-Frame — `COLOR_IDLE` in den Scripts anheben, nicht nur die Szene.
- Outline nicht umfärben (bleibt hell, auch bei Telegraph).
- `level_no_colorrect_visuals` nicht verletzen.
