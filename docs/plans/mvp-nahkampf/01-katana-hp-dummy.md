# Slice: Katana, HP, Dummy

**Aufgabe:** `docs/plans/mvp-nahkampf/`
**Status:** erledigt

## Ziel

Leichter und schwerer Katana-Hieb mit Hitboxes; Dummy mit Hurtbox und telegraphiertem Schlag; Spieler 100 HP ohne Regen; Tod bei 0 HP; Freeze-Frame plus Hurt-Flash.

Spieler kann auf der Greybox mit J/K den Dummy treffen (unterscheidbarer Schaden) und durch Dummy-Schläge sterben; Dodge-i-Frames gelten.

## Akzeptanzkriterien

- [x] Player J/K ruft `request_attack_light` / `request_attack_heavy` auf; kein Angriff während Dodge; Hitbox folgt `facing`
- [x] Leicht: kurze Active-Frames, kleine Box, `LIGHT_DAMAGE = 10`; Bewegung während des Hiebs reduziert
- [x] Schwer: Windup, größere Box, länger, `HEAVY_DAMAGE = 22`; Bewegung während Windup + Active gesperrt
- [x] Dummy auf Greybox: Hurtbox, Loop idle → Telegraph (Farbe) → Swipe → Pause; Dummy-Schlag `DUMMY_DAMAGE = 25` HP; Dummy stirbt nicht (Punching-Bag bleibt in der Schleife); Dummy-HP nur für Treffer-Nachweis
- [x] Spieler 100 HP, kein Regen; Hurtbox respektiert `invulnerable` (Dodge-i-Frames)
- [x] Tod bei 0 HP: Input aus, `reload_current_scene` nach `DEATH_RELOAD_DELAY = 2.0` s
- [x] Treffer-Feedback: Kamera-Shake plus Hurt-Flash auf dem Getroffenen (`Engine.time_scale = 0` hat Area2D-Treffer im Fenster kaputtgemacht)
- [x] Greybox-HP-Label am Spieler (kein HUD Stufe 6)
- [x] Health / Hitbox / Hurtbox als eigene Skripte (`scripts/health.gd`, `scripts/hitbox.gd`, `scripts/hurtbox.gd`) — nicht alles in `player.gd`
- [x] `scripts/dummy.gd` + `scenes/dummy.tscn`; Dummy in `scenes/main.tscn` instanziiert, auf dem Boden, in Laufweite
- [x] Physik- und Kampfwerte als benannte Konstanten; Tests importieren dieselbe Quelle (keine Magic Numbers in `tests/`)
- [x] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

### Stretch — Combokette L→L→H (kein Blocker)

Klar getrennt vom Pflicht-Scope. Fehlt die Combokette, gilt der Slice trotzdem als erfüllt, sobald die Kriterien oben grün sind.

- Nach einem leichten Hieb, im Anschluss-Fenster (`COMBO_FOLLOWUP_WINDOW`), kann Leicht oder Schwer die Recovery canceln.
- Kette laut KONZEPT §5.4: leicht → leicht → schwer. Nach zwei Leicht nur noch Schwer als Combo-Abschluss; nach Schwer endet die Kette.
- Eigene Tests nur wenn gebaut. Fehlender Stretch darf die Suite nicht rot machen.

## Automatisierte Tests

Befehl:

```bash
bash scripts/godot.sh --headless --path . -s tests/run_tests.gd
```

Bestehende Bewegungstests in `tests/run_tests.gd` bleiben und bleiben grün.

Neu (Headless, ohne GdUnit), Konstanten aus denselben Skripten wie die Spiel-Logik:

- Leicht trifft Dummy: Dummy-HP sinkt um `LIGHT_DAMAGE`
- Schwer trifft Dummy: Dummy-HP sinkt um `HEAVY_DAMAGE` (ungleich `LIGHT_DAMAGE`)
- Dummy-Swipe senkt Spieler-HP um `DUMMY_DAMAGE`; während Dodge / `invulnerable` nicht
- Start `Health.MAX_HP` (100); kein Regen über mehrere Frames
- Bei 0 HP: `dead`, keine Bewegung, kein Angriff
- Stretch nur wenn gebaut: L→L→H verkettet im Anschluss-Fenster (z. B. Guard hinter `Player.COMBO_ENABLED` oder fehlender Methode — Suite ohne Stretch nicht failen)

Tests spawnen Player + Dummy analog zu den Bewegungstests (World-Node, Boden, `request_*`, Physics-Frames). Freeze-Frame in Headless überspringen oder Dauer 0, damit `physics_frame` nicht hängt.

## In-Game-Checks

Verhalten im laufenden Spiel (nicht nur Unit-Tests). Start: F5 in Godot, oder `bash scripts/godot.sh --path .`

Playtest 2026-08-28: `bash scripts/godot.sh --path .` startete die Run-Szene (Fenster `Ninja Assassin (DEBUG)`), nicht den Editor. Zwei Durchläufe; V-Sync-Warning (llvmpipe), kein Start-Blocker.

- [x] J vs K am Dummy visuell und vom Feel her unterscheidbar (Tempo, Reichweite, Schaden)
- [x] Dummy telegraphiert (Farbe), dann Swipe
- [x] Dodge durch den Swipe: kein Schaden
- [x] In vier Swipes stehen bleiben → Tod → Szene lädt nach ~2 s neu
- [x] HP-Label am Spieler aktualisiert sich bei Treffer
- [x] Stretch optional: L→L→H ist gebaut (`COMBO_ENABLED`, Headless-Test grün); In-Game-Kette im Playtest nicht klar im Frame-Capture bestätigt (kein Blocker). Hurtbox-Parse-Error vom Neustart ist behoben.

## Out of scope

- Wurfsterne
- Echte Gegner-KI
- Heilung
- Checkpoints (Respawn am Schrein ist Stufe 4; hier nur Szenen-Reload)
- Luft-Angriff
- Block
- Pixel-Art
- HUD (Stufe 6) — nur Greybox-Label am Spieler
- Web-Export
- Level Nebliger Wald

## Architektur

Hitbox / Hurtbox / Health als eigene Skripte, damit Stufe 3 Gegner dieselben Bausteine nutzt.

```
Player --J/K--> PlayerHitbox --damage--> DummyHurtbox --> DummyHealth
Dummy --telegraph swipe--> DummyHitbox --damage if not iframes--> PlayerHurtbox --> PlayerHealth --hp 0--> PlayerDead
```

Neue Dateien:

| Datei | Rolle |
|-------|--------|
| `scripts/health.gd` | `MAX_HP` / `current`, `take_damage`, Signal `died` (und sinnvoll `damaged`); `immortal` für Dummy |
| `scripts/hitbox.gd` | `Area2D`, nur in Active-Frames aktiv, Team (`player` / `dummy`), kein Selbst-Hit |
| `scripts/hurtbox.gd` | `Area2D`, reicht Treffer an Health weiter, respektiert `invulnerable` am Owner |
| `scripts/dummy.gd` | Loop idle → Telegraph (Farbe) → Swipe → Pause; Hitbox nur im Swipe aktiv |
| `scenes/dummy.tscn` | Greybox-`ColorRect`s, Hurtbox, Hitbox, Health; kein Sprite |

Bestehend erweitern:

- `scripts/player.gd` / `scenes/player.tscn` — Input `attack_light` / `attack_heavy` (bereits in der Map) auf `request_attack_light` / `request_attack_heavy`; Health + Hurtbox + Hitbox als Kinder; Greybox-HP-Label; Tod-State
- `scenes/main.tscn` — Dummy-Instanz auf dem Boden, in Laufweite (Spieler startet bei `(160, 378)`; Dummy z. B. ~160 px rechts auf derselben Floor-Höhe)
- `project.godot` — Physics-Layer benennen und trennen (heute liegt alles auf Layer 1)

Empfohlene Layer (bit 0-indexiert):

| Layer | Name | Nutzung |
|-------|------|---------|
| 1 | `world` | StaticBody Greybox |
| 2 | `player` | Player-Body + Player-Hurtbox |
| 3 | `dummy` | Dummy-Body + Dummy-Hurtbox |
| 4 | `player_hitbox` | Spieler-Katana, mask `dummy` |
| 5 | `dummy_hitbox` | Dummy-Swipe, mask `player` |

Player-Body: layer `player`, mask `world`. Dummy-Body: layer `dummy`, mask `world`. Zusätzlich Team-String auf Hitbox/Hurtbox, damit gleicher Team-Typ nie sich selbst trifft.

## Benannte Konstanten (eine Quelle)

Werte in den Spiel-Skripten, Tests nur per Preload derselben Klasse. Feel darf leicht tunen, solange Leicht ≠ Schwer und die Zahlen in Tests nicht verdoppelt werden.

In `scripts/health.gd` (oder Combat-Konstanten, wenn ein Skript sie bündelt — dann eine Datei, keine Kopie):

| Konstante | Wert | Bedeutung |
|-----------|------|-----------|
| `MAX_HP` | `100` | Spieler-Start und Maximum; kein Regen |
| `LIGHT_DAMAGE` | `10` | Leichter Hieb |
| `HEAVY_DAMAGE` | `22` | Schwerer Hieb |
| `DUMMY_DAMAGE` | `25` | Dummy-Swipe; 4 Treffer = Tod, i-Frames verhindern |

Timing / Feel (Startwerte, benannt):

| Konstante | Startwert | Bedeutung |
|-----------|-----------|-----------|
| `LIGHT_WINDUP` | `0.04` s | optional kurz; darf 0 sein |
| `LIGHT_ACTIVE` | `0.08` s | kurze Active-Frames |
| `LIGHT_RECOVERY` | `0.16` s | |
| `LIGHT_MOVE_SCALE` | `0.35` | `velocity.x = axis * SPEED * LIGHT_MOVE_SCALE` während Leicht |
| `HEAVY_WINDUP` | `0.22` s | Telegraph/Windup, Bewegung lock |
| `HEAVY_ACTIVE` | `0.14` s | länger als Leicht-Active |
| `HEAVY_RECOVERY` | `0.28` s | |
| `LIGHT_HITBOX_SIZE` | kleiner als Heavy, z. B. `Vector2(28, 24)` | vor dem Spieler, folgt `facing` |
| `HEAVY_HITBOX_SIZE` | größer, z. B. `Vector2(44, 32)` | vor dem Spieler, folgt `facing` |
| `FREEZE_FRAME_DURATION` | `0.06` s | `Engine.time_scale` kurz 0, dann 1; Headless: 0 / skip |
| `HURT_FLASH_DURATION` | `0.08` s | Modulate-Flash auf dem Getroffenen |
| `DEATH_RELOAD_DELAY` | `2.0` s | danach `get_tree().reload_current_scene()` |
| `DUMMY_IDLE` | `0.6` s | |
| `DUMMY_TELEGRAPH` | `0.4` s | Farbe ändert sich (lesbar) |
| `DUMMY_ACTIVE` | `0.18` s | Swipe-Hitbox an |
| `DUMMY_PAUSE` | `0.8` s | Pause vor nächstem Loop; länger als Dodge-i-Frames (`0.22` s) |
| `COMBO_FOLLOWUP_WINDOW` | Stretch, z. B. Dauer der Light-Recovery | nur wenn Combokette gebaut |

Dummy-HP: dieselbe `Health`-Komponente, `immortal = true` (oder `current` darf auf 0, ohne `died` / ohne Loop-Stop). Dummy-HP ist nur Test-Nachweis, keine Todeslogik.

## Notizen für den Implementer

- Collision-Teams Player vs Dummy, damit Hitboxes sich nicht selbst treffen. Layer 1 nicht für alles belassen — sonst landet die Katana auf dem eigenen Body.
- Leicht: reduzierte Bewegung (`LIGHT_MOVE_SCALE`). Schwer: Bewegung während Windup + Active auf 0; Recovery darf wieder laufen. Facing während Schwer locken.
- Während Dodge keinen Angriff starten. Default: `request_dodge` bricht einen laufenden Hieb ab (Hitbox aus) — defensiv, analog zu „kein Angriff während Dodge“.
- Dummy unsterblich / greift weiter an, auch wenn HP rechnerisch 0 wäre. Kein `died`-Handling am Dummy.
- Tod: `died` → `dead`, Input/Move/Attack aus, kein Freeze-Frame extra für den Tod nötig; nach 2 s Szenen-Reload. Checkpoints erst Stufe 4.
- Combokette ist Stretch, kein Blocker. Keine Pflicht-API dafür, außer ihr baut sie — dann `COMBO_FOLLOWUP_WINDOW` + Test.
- Freeze-Frame bei jedem erfolgreichen Treffer (Spieler→Dummy und Dummy→Spieler). Hurt-Flash auf dem Getroffenen. Dodge-Flicker (`_update_iframe_visual`) nicht mit Hurt-Flash überschreiben, solange `invulnerable`.
- HP-Label: `Label` als Kind des Players, Text aus `current` HP, Greybox (kein CanvasLayer-HUD). Dummy braucht kein HP-Label.
- Dummy: `CharacterBody2D` oder fest auf dem Floor platziertes Node2D mit Collision; Greybox nur `ColorRect`. Telegraph = deutliche Farbe (z. B. Gelb/Orange), Swipe = andere Farbe (z. B. Rot).
- `throw` bleibt in der Input Map ungenutzt.
- Bewegung aus Stufe 1 unverändert lassen, außer wo Kampf sie überlagert (Move-Scale / Lock, kein Angriff im Dodge, Tod stoppt Input).
- Greybox nur primitive `ColorRect`s; keine Sprites, Tilesets oder Art-Assets.
