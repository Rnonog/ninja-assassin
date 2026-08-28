# Slice: Greybox Pixel Art

**Aufgabe:** `docs/plans/pixel-art-greybox/`
**Status:** implementiert

## Ziel

Godot-Greybox in hochauflösender Pixel-Art im Stil von `docs/design/ingame/ingame-level-hafen-godot.png`: Ninja als `AnimatedSprite2D` (Idle/Run/Jump/Fall/Dodge), 32px-Pier-Tiles für Boden und drei Plattformen, zweilagiger Parallax-Hintergrund (Hafensturm + Regen). Lesbarkeit auf 30"-4K durch mehr Sprite-Pixel, nicht durch Kamera-Zoom. Viewport bleibt 1280×720; Fenster skaliert integer (×3 auf 4K).

Ist-Zustand zum Ersetzen: `ColorRect`-Ninja (24×40 + Schärpe) in `scenes/player.tscn`, `ColorRect`-Boden/Plattformen/Hintergrund in `scenes/level_greybox.tscn`.

## Akzeptanzkriterien

- [ ] Ordner `assets/` existiert mit PNG-Sprites: Ninja-Sheets, 32px-Pier-Tiles, Hintergrund-Layer (Hafen + Regen)
- [ ] Import: Nearest-Neighbor, kein Filter, keine Mipmaps (Projekt-Default und/oder `.import`-Params)
- [ ] Player-Szene: `AnimatedSprite2D` ersetzt die `ColorRect`s (`Body`, `Sash`); Canvas 64×80; `CollisionShape2D` ≈32×64; Füße auf derselben Baseline wie die Kollision; `flip_h` folgt `facing`
- [ ] Animationen: Idle 4–6, Run 6–8, Jump 2–3, Fall 2, Dodge 4–6 Frames; Katana in der Scheide nur auf dem Sprite (keine Hitbox, keine Extra-Collision)
- [ ] i-Frame-Rot-Modulate-Flicker während Dodge bleibt erhalten (`Player.modulate` wie bisher in `_update_iframe_visual`)
- [ ] Boden: `TileMapLayer` (bevorzugt) oder gleichwertig; 32×32-Tiles, zwei Tiles hoch (64px Kollision), Laufstrecke ~2400px
- [ ] Drei Plattformen: gleiches Tileset, 32px hoch, X-Positionen 320 / 620 / 980, Breiten 176 / 160 / 192
- [ ] Hintergrund: 2-Layer-Parallax (ferne Kiefern + Nebel) ersetzt den `ColorRect`; kein Schrein, keine Gegner, kein Wasserfall
- [ ] Display: Viewport 1280×720, Integer-Stretch für 4K (×3)
- [ ] Physik-Konstanten in `scripts/player.gd` unverändert (`SPEED`, `JUMP_VELOCITY`, `JUMP_CUT_MULTIPLIER`, `COYOTE_TIME`, `JUMP_BUFFER`, `DODGE_SPEED`, `DODGE_DURATION`, `DODGE_COOLDOWN`, `IFRAME_DURATION`, `DODGE_GRAVITY_SCALE`)
- [ ] Headless-Tests grün, inkl. bestehender Physik-Tests; neue Tests für Animationsnamen + Collision-Shape der Player-Szene
- [ ] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt, nicht übersprungen

### Akzeptierte Extras (im Scope, User hat bestätigt)

Nicht als neue Ideen behandeln — umsetzen:

1. Zweilagiger Parallax: ferne Kiefern + Nebel (statt eines einzelnen flachen Pixel-Gemäldes).
2. Katana in der Scheide auf dem Ninja-Sprite, rein visuell, ohne Hitbox.
3. Integer-Window-Stretch für 4K (1280×720 ×3).

### Verbesserungsvorschläge (nicht umsetzen, außer User zieht nach)

- Weitere Parallax-Lagen, Partikel-Nebel, animierte Tiles, Bambus/Wasserfall/Dorf.
- Fenster fest auf 3840×2160 erzwingen (`window_width_override`) — Integer-Stretch reicht; Override würde kleinere Monitore sprengen.

## Automatisierte Tests

Befehl:

```bash
bash scripts/godot.sh --headless --path . -s tests/run_tests.gd
```

Bestehende Physik-Tests müssen grün bleiben. Sie spawnen `Player` per `PlayerGD.new()` mit eigener 24×40-Kollision und **ohne** Szenenbaum/`AnimatedSprite2D`. Animation-/Sprite-Code in `scripts/player.gd` darf nicht crashen, wenn `AnimatedSprite2D` fehlt (`get_node_or_null` o. ä.).

`_test_main_boot` bleibt: Main lädt ohne Fehler.

Neu in `tests/run_tests.gd` (Szene laden, nicht den Script-Player):

- `player.tscn` hat `CollisionShape2D` mit `RectangleShape2D.size` ungefähr 32×64 (Toleranz ±4 px zulässig)
- `AnimatedSprite2D` existiert; SpriteFrames enthalten die Animationsnamen `idle`, `run`, `jump`, `fall`, `dodge`
- Frame-Anzahlen in den geplanten Bereichen: idle 4–6, run 6–8, jump 2–3, fall 2, dodge 4–6
- `level_greybox.tscn` hat `TileMapLayer` (oder gleichwertige Tile-/Sprite-Visuals) und stützt Boden, Plattformen und Hintergrund **nicht** mehr allein auf `ColorRect`

Keine Änderung an den Physik-Assertions (Gravitation, Sprung, Coyote, Buffer, variable Höhe, Dodge-i-Frames). Test-Kollision der Physik-Fixtures bleibt 24×40 — das ist Absicht, nicht die Szenen-Kollision.

## In-Game-Checks

Verhalten im laufenden Spiel (nicht nur Unit-Tests). **Nicht überspringen.**

Start: F5 in Godot, oder `bash scripts/godot.sh --path .`

- [x] Szene startet; Ninja-Sprite sichtbar (kein `ColorRect`-Klotz)
- [x] Idle: Schal driftet; Run spielt bei Bewegung; Jump/Fall in der Luft; Dodge als Dash-Roll plus i-Frame-Rot-Flicker
- [x] Boden und Plattformen sehen nach nassem Pier-Holz / Stein aus dem Hafen-Mockup aus, nicht nach grauen Balken
- [x] Hintergrund ist nächtlicher Hafen im Sturm (Kran, Wasser, Blitz) plus Regen-Overlay, kein flächiges Fill
- [x] Sprites wirken knackig (Nearest Neighbor), lesbare Größe gegenüber dem alten 24×40-Klotz
- [x] Kollision: Stehen auf Boden und allen drei Plattformen, Springen dazwischen möglich
- [x] Blickrichtung flippt das Sprite (`facing` links/rechts)

### Playtest 2026-08-28 (spiel-playtester)

Headless-Suite laut Parent: **27/27 grün** (nicht erneut als Fensterlauf ausgeführt).

Spiel startete mit Godot 4.7.2 (`bash scripts/godot.sh --path .`, Main-Szene `scenes/main.tscn`, Display X11 / OpenGL Compatibility). Viewport-Frames 1280×720, Input wie ein Spieler (Bewegen/Sprung/Dodge/J/K). Kein Fix, nur Beobachtung.

| Check | Ergebnis | Schritte | Erwartet | Ist | Blockt? |
| --- | --- | --- | --- | --- | --- |
| Szene + Ninja-Sprite | **Pass** | Boot, Idle-Frames | Pixel-Ninja, kein Body/Sash-`ColorRect` | Schwarzer Ninja, rote Schärpe/Armwickel, Katana; Dummy bleibt `ColorRect` (out of scope) | nein |
| Idle / Run / Jump / Fall / Dodge+i-Frame | **Pass** | Idle 0.5s; D halten; Sprung am Spawn ohne Unterplattform; Shift-Dodge | Idle-Schal; Run am Boden; Jump nach oben, Fall in der Luft; Dodge-Roll + rotes Modulate | Idle-Frames wechseln (`idle#1`→`#0`); `run` bei vx=180; offener Sprung `jump#0` vel.y≈−404, danach `fall#0`; Dodge `dodge#0`, `invulnerable`, modulate `(1, 0.45, 0.45)` mit Alpha-Puls 0.67–1.0 | nein |
| Boden/Plattformen Holz/Stein | **Pass** | Blick auf Floor + drei Tile-Plattformen | Nasses Pier-Holz/Stein, keine grauen Balken | Wooden-Planks + Stein links; Plattformen als Holzkisten-Tiles; Hafen-BG malt zusätzlich den Pier | nein |
| Hafen-Sturm + Regen | **Pass** | Boot und Lauf nach rechts | Nacht-Hafen (Kran, Wasser, Blitz) + Regen, kein Flat-Fill | Blitz, Kräne, Schiffe, Wasser, diagonaler Regen. Hinweis (nicht blockend): rechts graue Kante, wenn die Kamera den BG-Rand überrollt | nein |
| Knackige Sprites | **Pass** | Idle/Run-Close-up | Nearest Neighbor, lesbarer als 24×40 | Scharfe Pixel, 64×80-Ninja mit roter Schärpe klar lesbar | nein |
| Kollision 3 Plattformen | **Pass** (Retest nach Absenken) | Floor stehen; Sprung von links auf P1, P2, P3; `on_floor` je Landung | Stehen auf Floor **und allen drei** Plattformen | Floor ja (y=368, feet=400). **P1 ja** (Landung (309, 308), feet=340, `on_floor`). **P2 ja** (Landung (584, 288), feet=320). **P3 ja** (Landung (898, 278), feet=310). Apex weiterhin ≈94px (`JUMP_VELOCITY` −420). Plattform-Tops 340 / 320 / 310 | nein |
| Facing flip | **Pass** | A nach Idle/Run rechts | `flip_h` bei facing −1 | `facing=-1`, `flip_h=true`, Dodge nach links ebenfalls geflippt | nein |
| Combat (zusätzlich) | **Pass** | Dummy auf dem Pier; J und K | Dummy sichtbar; J/K lösen Hitbox aus | Dummy bei (300, 380); J Light (phase Recovery); K Heavy, gelbes Hit-Visual an; Dummy-Swipe senkt Spieler-HP 100→75 | nein |

Retest Kollision (Plattformen abgesenkt, `JUMP_VELOCITY` unverändert −420): Floor → P1 → Floor → P2 → Floor → P3. Alle drei Landungen `on_floor`, Füße auf Tops 340 / 320 / 310. Apex weiter ≈94px.

## Out of scope

- Attack-/Throw-/Hurt-/Death-Animationen
- Gegner
- HUD
- Pickups
- Schrein
- Volles Nebliger-Wald-Tileset (Bambus, Wasserfall, Dorf, verbranntes Dorf)
- NY-Palette
- Combat-VFX
- `SPEED` / `JUMP_*` / `DODGE_*` / `IFRAME_*` / `COYOTE_TIME` / `JUMP_BUFFER` ändern
- KONZEPT Stufe 6 abschließen (Atmosphäre/HUD/Export bleibt `offen`)
- Cursor-Plan-Dateien unter `.cursor/plans/` nicht bearbeiten

## Notizen für den Implementer

### Ist-Zustand (nicht stillschweigend umbauen)

- `scenes/player.tscn`: `CharacterBody2D` + `CollisionShape2D` 24×40, `ColorRect` `Body`/`Sash`, `Camera2D`. Spawn in `scenes/main.tscn`: `Vector2(160, 378)`.
- `scenes/level_greybox.tscn`: Hintergrund-`ColorRect`; Boden `StaticBody2D` bei `(1000, 424)`, Kollision 2400×48 (Oberkante y=400); Plattformen bei X 320/620/980, Höhen 20px, Breiten 180/160/200.
- Viewport in `project.godot` bereits 1280×720; Stretch-Mode fehlt noch.
- i-Frame-Visual: `modulate` auf dem Player-Node — beibehalten, wirkt dann auf das Sprite.

### Pixel-Art

- Stil: High-res Pixel-Art nach `docs/design/ingame/ingame-level-hafen-godot.png` (Schwarze Shōzoku, rote Schärpe/Armwickel, Katana, nasses Pier-Holz, Sturm-Hafen).
- Palette Japan (kein NY-Neon):

  | Name | Hex |
  |------|-----|
  | Ink | `#0D0C10` |
  | Charcoal | `#1A181C` |
  | Scarf | `#8B1A1F` / `#C43C3C` |
  | Moonlight | `#7A9BB8` |
  | Bone | `#C8C2B4` |
  | Pine | `#1C2A22` |
  | Moss | `#2F3D32` |
  | Fog | `#3D4A48` |
  | Earth | `#3A3830` |
  | Stone | `#5C5E56` |

- Ninja-Canvas 64×80; Kollision schmaler (~32×64), Füße bündig mit Sprite-Unterkante (Sprite-Offset, nicht Hitbox an Canvas koppeln).
- Katana nur gezeichnet (Scheide am Rücken/Hüfte), kein zweites Collision-Shape.
- Dodge: Dash-Roll, 4–6 Frames. Idle: Schal-Drift.

### Godot / Szenen

- Godot 4.7: `TileMapLayer` + `TileSet`, nicht das deprecated `TileMap`.
- Import: `mipmaps/generate=false`; Filter Nearest. Projektweit `textures/canvas_textures/default_texture_filter=0` (Nearest) ist sinnvoll, damit nichts linear hochskaliert.
- Integer-Stretch in `project.godot`, z. B. `window/stretch/mode` (`viewport` oder `canvas_items`), `aspect=keep`, `scale_mode=integer`. Viewport **nicht** auf 4K erhöhen. Kein festes 3840×2160-Override.
- Animation in `_physics_process` nach der Bewegung: idle (Boden, Axis≈0), run (Boden, Bewegung), jump (`velocity.y < 0`), fall (`velocity.y >= 0` in der Luft), dodge (`_dodging`). `flip_h` aus `facing`. Zugriff auf das Sprite **absichern**.
- Spawn-Y in `main.tscn` anpassen: Boden wird 64px hoch (vorher 48). Oberkante des Bodens nah an der heutigen y=400 lassen, damit die unveränderte Sprunghöhe zu den Plattformen passt; Player-Füße (halbe Kollisionshöhe 32) darauf setzen.
- Plattform-Oberkanten nach Playtest 2026-08-28 auf Sprungweite gesenkt (P1 y=340, P2 y=320, P3 y=310), **ohne** `JUMP_VELOCITY` zu ändern. Tiles folgen den StaticBodies.
- Breite 176 ist kein Vielfaches von 32. Kollision trotzdem 176/160/192 wie spezifiziert; Tile-Visuals dürfen überstehen oder die letzte Kachel anschneiden — Breiten nicht still auf 160/192 „korrigieren“.
- `Camera2D` am Player behalten.
- Dateien unter `.cursor/plans/` nicht anfassen.
