# Slice: Godot, Player, Greybox

**Aufgabe:** `docs/plans/mvp-steuerung/`
**Status:** erledigt

## Ziel

Godot-4-Projekt mit Greybox-Teststrecke und Player-Controller: Laufen, Einfachsprung, Ausweichen mit i-Frames.

## Akzeptanzkriterien

- [x] Godot 4.7.2 Projekt im Repo-Root: `project.godot`, `scenes/main.tscn`, `scenes/player.tscn`, `scenes/level_greybox.tscn`, `scripts/player.gd`
- [x] Input Map: `move_left` / `move_right` (A/D + Pfeiltasten), `jump` (Space), `dodge` (Shift), `attack_light` J, `attack_heavy` K, `throw` L, `pause` Esc (Kampf-Actions ungenutzt)
- [x] CharacterBody2D: Gravitation, Laufen, Einfachsprung, Ausweichen mit i-Frames (`invulnerable`), Kamera folgt dem Spieler
- [x] Coyote-Time + Jump-Buffer 80–120 ms; variable Sprunghöhe (Leertaste loslassen kürzt den Aufstieg) — User-bestätigt, **in scope**
- [x] Greybox-Boden plus 2–3 Plattformen als `ColorRect` + `StaticBody2D` — keine Pixel-Art
- [x] `scripts/install-godot.sh` lädt `Godot_v4.7.2-stable_linux.x86_64.zip` nach `tools/`
- [x] `scripts/godot.sh` wrappt `godot` aus PATH oder `tools/Godot_v4.7.2-stable_linux.x86_64`
- [x] `.gitignore`: `.godot/` und `tools/`
- [x] Automatisierte Tests sind grün
- [x] In-Game-Checks (unten) sind ausgeführt, nicht übersprungen

## Automatisierte Tests

Befehl:

```bash
bash scripts/godot.sh --headless --path . -s tests/run_tests.gd
```

Headless-Runner ohne GdUnit. `tests/run_tests.gd` deckt ab:

- Projekt startet ohne Fehler (`--quit-after 1` auf Main)
- Input-Actions existieren (`move_left`, `move_right`, `jump`, `dodge`, `attack_light`, `attack_heavy`, `throw`, `pause`)
- Gravitation zieht den Spieler nach unten
- Sprung vom Boden setzt negatives `velocity.y`
- Coyote: Sprung ist kurz nach Verlassen des Bodens noch möglich
- Buffer: Sprung, der kurz vor der Landung gedrückt wird, wird ausgeführt
- Variable Höhe: Loslassen von Jump reduziert die Aufwärtsgeschwindigkeit
- Dodge setzt `invulnerable` und hebt es nach der Dauer wieder auf

## In-Game-Checks

Verhalten im laufenden Spiel (nicht nur Unit-Tests). **Nicht überspringen.**

Start: F5 in Godot, oder `bash scripts/godot.sh --path .`

Playtest 2026-08-28: `bash scripts/godot.sh --path .` startete die Run-Szene (Fenster `Ninja Assassin (DEBUG)`), nicht den Editor.

- [x] Szene startet (Main lädt Greybox + Player)
- [x] ~30 s Bewegung: Sprunghöhe, Landung, Ausweich-Distanz (Roll) fühlen sich unmittelbar an
- [x] i-Frames sichtbar (Modulate-Flicker während Dodge)
- [x] Kurzer vs. gehaltener Sprung unterscheidbar

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

## Notizen für den Implementer

- Physik-Konstanten (Gravitation, Laufgeschwindigkeit, Sprungimpuls, Coyote-/Buffer-Fenster 80–120 ms, variable Sprungkürzung, Dodge-Dauer/-Distanz, i-Frame-Dauer) in `scripts/player.gd` als benannte Konstanten halten und in den Headless-Tests dieselbe Quelle nutzen — keine zweiten Magic Numbers in `tests/`.
- Godot-Binary nicht committen; nur Wrapper + Install-Skript. Binary liegt in `tools/` (gitignored).
- Kampf-Input (`attack_light`, `attack_heavy`, `throw`) in der Input Map binden, im Player-Controller nicht auswerten.
- Einfachsprung only: kein zweiter Sprung in der Luft, auch nicht als Rest-State.
- Coyote-Time, Jump-Buffer und variable Sprunghöhe sind festes Feel, keine optionalen Extras.
- Greybox nur primitive `ColorRect`/`StaticBody2D`-Kollision; keine Sprites, Tilesets oder Art-Assets.
- `scenes/main.tscn` ist die Run-Szene: instanziiert Level + Player, Kamera folgt dem Player.
