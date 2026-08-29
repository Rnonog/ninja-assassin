# Slice: Zonen, Schrein, Respawn

**Aufgabe:** `docs/plans/mvp-wald/`
**Status:** implementiert
**Slice-ID:** `01-level-checkpoint`
**KONZEPT:** §12.1 Stufe 4 — Level *Nebliger Wald*

## Ziel

Links-nach-rechts Hafen-Greybox, gestreckt: Einstieg Dummy (~x=300) → Kampfzone 1 (1 Schläger, 1 Wurfkämpfer, 1 Ammo) → Schrein-Checkpoint → Plattform+Kill-Plane-Grube → Kampfzone 2 (2 Schläger, 1 Wurfkämpfer) → Heal+Ammo → leere Arena → Exit-Marker.

Ein Schrein, Auto-Aktivierung bei Overlap. Tod oder Fall in die Grube: nach ~2 s Respawn am letzten Checkpoint mit `MAX_HP` und Munitions-Snapshot der Aktivierung — **dieselbe Player-Instanz**, kein `reload_current_scene`. Start-Spawn ist impliziter Checkpoint (`START_AMMO`), bis der Schrein aktiv ist.

Hafen-Tiles und Parallax bleiben; Boden wird gestreckt. `JUMP_VELOCITY` unverändert. Dummy bleibt unsterblicher Punching-Bag am Einstieg.

## Akzeptanzkriterien

Alles testbar (Headless). Werte nur aus einer Konstanten-Quelle (`Health` / `Player`), nicht als Magic Numbers in Tests.

- [x] **Layout-Reihenfolge** in `scenes/main.tscn` (x aufsteigend, Y auf Floor-Höhe):
  1. Einstieg: Dummy ~x=300
  2. Kampfzone 1: genau 1 Thug, 1 Thrower, 1 Ammo-Pickup
  3. Schrein (Checkpoint)
  4. Plattform+Grube (Kill-Plane)
  5. Kampfzone 2: genau 2 Thugs, 1 Thrower
  6. Supply: genau 1 Heal-Pickup + 1 Ammo-Pickup
  7. leere Arena (Marker, keine Gegner)
  8. Exit-Marker
- [x] **Hafen-Art bleibt:** Tiles (`pier.png`) und Parallax (`harbor.png` / `rain.png`) in `level_greybox.tscn` behalten. Boden/Tiles nach rechts strecken; Lücke nur an der Grube. Kein Wald-Tileset, keine neuen Pixel-Assets.
- [x] **`JUMP_VELOCITY` unverändert** (`Player.JUMP_VELOCITY`, aktuell −420). Kein Dodge-/Combo-/Speed-Retune.
- [x] **Freier Bodenweg in Kampfzonen:** Plattformen **nur über der Grube**. Keine Plattform auf dem Einstiegsweg. Konkret: heutiges `Platform1` bei x≈320 hat linke Kante ≈232 und blockiert den Weg — das darf nicht bleiben. `Platform1`/`Platform2`/`Platform3` **Knotennamen behalten**, Positionen über die Grube verschieben.
- [x] **Ein Schrein:** `scenes/checkpoint.tscn` — ein `ColorRect` (Greybox), Auto-Aktivierung bei Player-Overlap. ColorRect **nicht** in `level_greybox.tscn` (sonst fällt `level_no_colorrect_visuals`).
- [x] **Respawn statt Reload:** Tod (0 HP) oder Kill-Plane-Fall → nach `Player.DEATH_RELOAD_DELAY` (~2 s) `Player.respawn(position, ammo)` am letzten Checkpoint. `Health.restore_full()`. Kein `reload_current_scene`. Dieselbe Player-Instanz.
- [x] **Munitions-Snapshot:** Bei Schrein-Aktivierung aktuelle `shuriken_ammo` speichern. Respawn setzt genau diesen Stand (nicht Inventar beim Tod). Bis zur ersten Schrein-Aktivierung gilt der Start-Spawn mit `Health.START_AMMO`.
- [x] **Persistenz:** Tote Gegner bleiben `is_dead`. Aufgesammelte Pickups bleiben weg (`queue_free`, kein Scene-Reload).
- [x] **Neue Dateien (Pflicht):**
  - `scripts/checkpoint.gd` + `scenes/checkpoint.tscn`
  - `scripts/run_session.gd` am Node `Main`
  - `scripts/kill_plane.gd`
- [x] **Player:** `respawn(position, ammo)` — hebt `is_dead`, teleportiert, setzt Munition, Labels, Velocity/Angriff zurück.
- [x] **Health:** `restore_full()` setzt `current = max_hp` **auch wenn tot** (`heal()` lehnt `current == 0` ab — nicht dafür missbrauchen).
- [x] **Dummy:** bleibt ~x=300, `immortal`, Loop unverändert. Nicht entfernen, nicht töten.
- [x] **Kein Boss**, keine neue Pixel-Art, kein Fallenleger, Dummy bleibt.
- [x] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

## Automatisierte Tests

Headless-Pflicht (Merge-Gate, kein Fenster):

```bash
bash scripts/run-tests.sh
```

Äquivalent: `bash scripts/godot.sh --headless --path . -s tests/run_tests.gd`

Bestehende Stufe-1–3-Tests in `tests/run_tests.gd` bleiben und bleiben grün, inkl. `main_boot`, `platforms_within_jump` (`reach_platform1`/`2`/`3`) und `level_no_colorrect_visuals`.

Neu (Headless, ohne GdUnit). Konstanten per Preload derselben Klasse wie die Spiel-Logik (`Health`, `Player`). Respawn-Timer in Headless **nicht** skippen (im Gegensatz zum alten Scene-Reload).

| Test | Erwartung |
|------|-----------|
| Schrein speichert Munition | Overlap bei `shuriken_ammo != START_AMMO` speichert den Stand. Tod → nach `DEATH_RELOAD_DELAY` Position am Schrein, `health.current == MAX_HP`, `shuriken_ammo` = gespeicherter Stand |
| Tod vor Schrein | Kein Schrein aktiv. Tod → Start-Spawn (Player-Startposition aus `main.tscn`), `START_AMMO`, `MAX_HP` |
| Kill-Plane-Fall | Fall in die Grube → derselbe Respawn-Pfad (Delay, Checkpoint, `MAX_HP`, Snapshot). **Dieselbe Player-Instanz** (`get_instance_id()` unverändert, kein neues Player-Node) |
| Tote Gegner bleiben tot | Thug auf 0 HP (`is_dead`), dann Spieler-Respawn → Thug weiterhin `is_dead`, greift nicht an |
| Pickup bleibt weg | Ammo-Pickup einsammeln (`queue_free`), Respawn → Pickup nicht wieder da |
| Layout-Ordnung | `main.tscn`: Dummy.x ≈ 300 (±40). Schrein.x > Zone-1-Akteure. Arena-Marker.x > Zone-2-Akteure. Exit.x > Arena. Plattformen **nicht** auf dem Einstiegsweg: `Platform1`/`2`/`3`.x alle **rechts vom Schrein** (über der Grube), keine Plattform-AABB über Dummy/Einstieg (kein Blocker bei x≈232) |
| `platforms_within_jump` | Knotennamen `Platform1`/`Platform2`/`Platform3` und `Floor` bleiben. Tops mit aktuellem `JUMP_VELOCITY` erreichbar (bestehende Formel). Plattformen dürfen nur horizontal wandern + leichtes Y im erlaubten Apex |
| `level_no_colorrect_visuals` | `level_greybox.tscn` gewinnt **keine** `ColorRect`s. Schrein-ColorRect lebt in `checkpoint.tscn` / unter `Main` |
| `main_boot` | `scenes/main.tscn` instanziiert ohne Fehler (inkl. `RunSession`, Checkpoint, Kill-Plane, gestrecktes Level) |
| Stufe 1–3 grün | Bewegung, Dummy, J/K, Dodge, Tod-Stop, Combo, Wurf, Pickups, Thug/Thrower, Art-Checks — unverändert |

Hilfen analog bestehender Combat-Spawns. Für Checkpoint/Kill-Plane/Layout: `main.tscn` laden **oder** Mini-World mit `RunSession` + Checkpoint + KillPlane + Player + Boden/Grube. Freeze-Frame in Headless weiter skippen.

`death_stops_move_and_attack` bleibt: bei 0 HP sofort `is_dead`, keine Bewegung/Angriff — Respawn erst nach Delay.

Nicht nach Hardcoded-HP/Ammo-Zahlen suchen; `HealthGD.MAX_HP`, `HealthGD.START_AMMO`, `PlayerGD.DEATH_RELOAD_DELAY` preloaden.

## In-Game-Checks

Visuelle In-Game-Checks nur auf ausdrücklichen User-Wunsch; sonst überspringen mit Begründung. Default ist die headless-Suite, kein Fensterspiel.

Start (nur wenn User Playtest verlangt): F5 in Godot, oder `bash scripts/godot.sh --path .` — kein Editor-Fokus stehlen.

- [ ] Links-nach-rechts: Dummy → Zone 1 → Schrein → Grube/Plattformen → Zone 2 → Heal/Ammo → leere Arena → Exit; Kampfzonen zu Fuß ohne Plattform-Blocker
- [ ] Schrein aktiviert bei Betreten; Tod respawnt dort mit vollem Leben und Snapshot-Munition
- [ ] Fall in die Grube respawnt ebenso; Spieler-Node bleibt dieselbe Instanz
- [ ] Dummy links (~x=300) unsterblich; Plattformen nur über der Grube, Sprung mit aktuellem JUMP
- [x] Übersprungen, weil: kein ausdrücklicher User-Wunsch nach visuellem Playtest — Default ist headless, kein Godot-Editor, kein Fensterspiel, kein Fokus-Diebstahl.

## Playtest-Ergebnis (spiel-playtester)

- **Headless:** PASS (cited existing result, suite not re-run): `bash scripts/run-tests.sh` — **50 passed, 0 failed**. Confirmed by implementer and code-reviewer; this playtester did not re-run the long suite.
- **Visual In-Game-Checks:** SKIPPED — user did not request visual playtest. No windowed Godot, no Godot editor, no focus steal.
- **Merge-Blocker:** none.

## Out of scope

- Boss / Klan-Schläger-Hauptmann
- Arena schließt sich
- Intro-Cutscene
- Wald-Pixel-Art / neues Tileset (Hafen-Tiles bleiben)
- Nebel-Partikel
- HUD-Canvas (Stufe 6) — Greybox-Labels am Spieler bleiben
- Fallenleger / Shuriken-Falle
- Axt-Kämpfer
- Wasserfall-Puzzle
- JUMP / Dodge / Combo retunen (`JUMP_VELOCITY` bleibt)
- Dummy-Tod oder Dummy entfernen
- Web-Export
- Scene-Reload als Todes-Pfad (wird durch Respawn ersetzt)
- Sieg-/Niederlage-Bildschirm (Stufe 5)

## Architektur

```
Start: RunSession speichert Spawn-Position + START_AMMO (impliziter Checkpoint)

Checkpoint --player overlap--> RunSession.activate(position, current_ammo)

Player.health.died | KillPlane.player_fell
        --> ~DEATH_RELOAD_DELAY (2 s)
        --> Player.respawn(last_position, last_ammo)
        --> Health.restore_full()   # auch wenn current == 0
        --> dieselbe Player-Instanz; Gegner/Pickups unangetastet

Kein tree.reload_current_scene()
```

Neue Dateien:

| Datei | Rolle |
|-------|--------|
| `scripts/checkpoint.gd` | Area2D: Overlap mit Gruppe `player` → Signal/Callback an `RunSession` mit Position + `shuriken_ammo`. Ein Schrein. |
| `scenes/checkpoint.tscn` | Greybox-`ColorRect` + Collision. **Nicht** Kind von `LevelGreybox`. |
| `scripts/run_session.gd` | Am `Main`: letzter Checkpoint (Pos + Ammo). Start-Spawn als Default. Lauscht auf Tod und Kill-Plane. Nach Delay `respawn`. |
| `scripts/kill_plane.gd` | Area2D unter der Grube; Player-Overlap → derselben Todes-/Respawn-Pipeline (Delay, Checkpoint). |

Bestehend erweitern:

- `scripts/player.gd` — `respawn(position, ammo)`; `_on_died` startet **keinen** Scene-Reload mehr (`_reload_if_playing` entfernen oder tot lassen). Delay über `RunSession` oder Player-Timer, der `RunSession` aufruft. `DEATH_RELOAD_DELAY` behalten (2 s).
- `scripts/health.gd` — `restore_full()`: `current = max_hp`, unabhängig von `current == 0`.
- `scenes/main.tscn` — `RunSession`-Skript auf `Main`; Checkpoint, Kill-Plane, Zone-2-Gegner, Supply, Arena-/Exit-Marker; Dummy ~x=300.
- `scenes/level_greybox.tscn` + `scripts/level_greybox.gd` — Floor strecken, Gruben-Lücke in Tiles + Kollision; `Floor`-Knotenname bleibt (linkes Segment); `FloorRight` (Name frei, nicht `Floor` ersetzen) für das rechte Ufer; `Platform1`/`2`/`3` über die Grube; Parallax unverändert. **Keine ColorRects.**

`platforms_within_jump` liest `level.get_node("Floor")` und `Platform1`/`2`/`3`. Diese Namen nicht umbenennen. Floor-Oberkante (y) nicht anheben.

## Benannte Konstanten (eine Quelle)

Keine neuen Kampfwerte. Pflicht unverändert:

| Konstante | Quelle | Bedeutung |
|-----------|--------|-----------|
| `JUMP_VELOCITY` | `Player` | unverändert (−420); Plattform-Tops weiter in Reichweite |
| `DEATH_RELOAD_DELAY` | `Player` | ~2 s bis Respawn (vorher Scene-Reload) |
| `MAX_HP` | `Health` | Respawn immer voll |
| `START_AMMO` | `Health` | Snapshot des impliziten Start-Checkpoints |

## Platzierung in `scenes/main.tscn` / Level

Spieler bleibt ~(160, 368). Dummy bleibt ~(300, 380). Zahlen dürfen leicht, **Ordnung und Dummy-x** nicht. Vorschlag (Feel, Steg nach rechts strecken; Grube breiter als Ein-Sprung-Weite ~150 px, damit Kisten nötig sind):

| Node | x (ungefähr) | Rolle |
|------|----------------|-------|
| Player | **160** | Start-Spawn = impliziter Checkpoint |
| Dummy | **300** | Punching-Bag, unverändert |
| AmmoPickup | ~500–700 | Zone 1, 1× Munition |
| ClanThug | ~750–900 | Zone 1 |
| ThrowFighter | ~950–1100 | Zone 1 |
| Checkpoint | ~1200–1400 | rechts von Zone 1, links von der Grube |
| KillPlane + Platform1/2/3 | ~1500–2100 | nur hier Plattformen; Floor-Lücke |
| ClanThug2, ClanThug3, ThrowFighter2 | ~2300–2900 | Zone 2, freier Boden |
| HealPickup, AmmoPickup2 | ~3000–3200 | Supply vor Arena |
| ArenaMarker | ~3400–3800 | leer, keine Gegner, kein Tor |
| ExitMarker | > Arena | `Marker2D` (kein ColorRect in `level_greybox`) |

Y: Dummy-Muster ~380 Körper, Pickups auf dem Deck (~392). Floor-Top unverändert (~400), sonst bricht `platforms_within_jump`.

Knoten-Vorschlag Zone 2 / Supply: `ClanThug2`, `ClanThug3`, `ThrowFighter2`, `AmmoPickup2`. Layout-Test darf diese Namen oder Gruppen+x-Sortierung nutzen — einmal festlegen und in Tests verwenden.

Heute: `Platform1` bei (320, 356), Breite 176 → linke Kante **x≈232** auf dem Einstieg. Alle drei Plattformen nach der Grube; Einstieg und beide Kampfzonen ohne Overhead-Kisten.

## Verbesserungsvorschläge (nicht im Pflicht-Scope)

Klar getrennt. Nur bauen, wenn der User zustimmt — sonst ignorieren.

- **Kurze Respawn-i-Frames** (z. B. 0.2–0.5 s), damit Zone-1-Thug nicht in der ersten Frame sticht. Feel, kein Blocker; Pflicht-Tests prüfen HP/Ammo/Position, nicht i-Frames.
- **Schrein-Farbe nach Aktivierung** (ColorRect dunkler/heller), damit der Checkpoint lesbar ist. Rein visuell; Headless muss das nicht prüfen.
- **Grube breiter als Max-Sprungweite**, damit die Kisten Pflicht sind. Empfohlen fürs Feel; Layout-Test prüft nur Positionen, nicht „unüberspringbar“.

## Notizen für den Implementer

- `Player._on_died` setzt weiter sofort `is_dead`, bricht Angriff ab, Velocity 0. **Nicht** `reload_current_scene`. Headless darf den Respawn-Timer **nicht** mehr überspringen (alter Guard in `_reload_if_playing` gilt nur für Reload).
- `heal()` nicht für Respawn: bei `current == 0` no-op. Immer `restore_full()` in `respawn`.
- `respawn(position, ammo)`: `is_dead = false`, `_reload_started = false`, `invulnerable` zurücksetzen (außer optionalen i-Frames), `health.restore_full()`, `shuriken_ammo = ammo` (cap `MAX_AMMO` ok), `global_position = position`, Velocity 0, Attack cancel, HP-/Ammo-Labels. Player-Node nicht `queue_free` / neu instantiieren.
- `RunSession` auf `Main`: in `_ready` Startposition + `START_AMMO` speichern. Checkpoint-Signal überschreibt. Ein Schrein reicht; erneutes Overlap darf Snapshot aktualisieren (aktuelles Ammo).
- Kill-Plane: `collision_mask` auf Player-Layer (2); `monitoring`. Bei Overlap dieselbe Pipeline wie `died` (nicht extra HP-Schaden nötig, außer es vereinfacht — dann trotzdem gleiche Delay/Respawn-API). Unter der Grube breit genug, dass Vorbeifallen nicht möglich ist.
- Floor split: `Floor` = linkes Ufer (Einstieg bis Grube). Zweites StaticBody für rechts. Lücke = Grube. Tiles: `FLOOR_COLS` erhöhen, Zellen in der Lücke **nicht** setzen. `PLATFORMS` in `level_greybox.gd` an die neuen Kisten-Positionen koppeln (Atlas wie bisher).
- `level_no_colorrect_visuals` sammelt ColorRects **in** `level_greybox.tscn`. Schrein, Labels, Gegner-Greybox liegen außerhalb — nicht den Schrein unter `LevelGreybox` hängen.
- Dummy nicht verschieben (x≈300), nicht auf `enemy`-Layer, `immortal` bleibt.
- Keine neuen Sprites/Atlas-Dateien. Hafen-Parallax `motion_mirroring` 1280 behalten (wiederholt sich nach rechts).
- Tests: `main_boot` nach Layout-Änderung grün halten. `platforms_within_jump` nicht umbauen außer Floor/Platform-Pfade bleiben gültig; Tops nicht über Apex heben.
- Eine Slice; keine Extra-Dateien außer den drei Pflicht-Neuen (+ `checkpoint.tscn`).
