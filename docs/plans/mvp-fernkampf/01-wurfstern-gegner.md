# Slice: Wurfstern, Pickups, Schläger, Wurfkämpfer

**Aufgabe:** `docs/plans/mvp-fernkampf/`
**Status:** implementiert
**Slice-ID:** `01-wurfstern-gegner`
**KONZEPT:** §12.1 Stufe 3 — Fernkampf & Gegner

## Ziel

Spieler wirft Wurfsterne mit **L** in `facing`-Richtung bei begrenzter Munition; Ammo- und Heal-Pickups auf dem Steg; Klan-Schläger jagt und sticht mit Telegraph; Wurfkämpfer hält Distanz, telegraphiert, wirft. Dummy aus Stufe 2 bleibt Punching-Bag links (~x=300).

Nahkampf bleibt stärker als Fernkampf (`SHURIKEN_DAMAGE` < `LIGHT_DAMAGE`). Greybox: nur `ColorRect`-Platzhalter, keine neuen Pixel-Sprites.

## Akzeptanzkriterien

Alles testbar (Headless und/oder In-Game). Werte nur aus einer Konstanten-Quelle (siehe unten), nicht als Magic Numbers in Tests.

- [x] **L ist Wurf:** Input-Action `throw` (bereits auf L) ruft `Player.request_throw` auf. Wurf in `facing` (horizontal). Kein Wurf während Dodge. Kein Wurf während Heavy-Windup und Heavy-Active. Kein Projektil bei 0 Munition.
- [x] **Munition & Schaden:** `SHURIKEN_DAMAGE = 6` und `SHURIKEN_DAMAGE < LIGHT_DAMAGE` (10). Start `START_AMMO = 5`. Pickup `AMMO_PICKUP = 3`. Cap `MAX_AMMO = 10`. Projektilgeschwindigkeit `SHURIKEN_SPEED` ≈ 420.
- [x] **Heilung:** Pickup `HEAL_PICKUP = 30`. `Player.heal(amount)` / `Health.heal(amount)` füllt HP, Cap `MAX_HP = 100`. Kein HP-Regen.
- [x] **Platzhalter:** Neue Gegner, Pickups und Wurfsterne sind `ColorRect`-Greybox. Keine neuen Pixel-Sprites / Atlas-Assets in diesem Slice.
- [x] **Szene:** Dummy bleibt ~x=300. Schläger und Wurfkämpfer weiter rechts auf dem Steg. Genau 1 Ammo-Pickup und 1 Heal-Pickup in `scenes/main.tscn`.
- [x] **Klan-Schläger:** Läuft auf den Spieler zu. Kurzer Stich mit Telegraph (Farbe wie Dummy: Telegraph gelb/orange, Active rot). Stirbt bei 0 HP (`THUG_MAX_HP = 40`). `THUG_DAMAGE = 15`.
- [x] **Wurfkämpfer:** Hält Distanz. Wirft nur nach sichtbarem Telegraph. Wurfstern-Treffer während Telegraph bricht den Wurf ab (kein Projektil). Stirbt bei 0 HP (`THROWER_MAX_HP = 30`). `THROWER_DAMAGE = 10`.
- [x] **Neue Dateien (Pflicht):**
  - `scripts/projectile.gd` + `scenes/shuriken.tscn`
  - `scripts/pickup.gd` + `scenes/ammo_pickup.tscn` + `scenes/heal_pickup.tscn`
  - `scripts/clan_thug.gd` + `scenes/clan_thug.tscn`
  - `scripts/throw_fighter.gd` + `scenes/throw_fighter.tscn`
- [x] **Player:** `request_throw`, `shuriken_ammo`, Greybox-Ammo-Label (kein CanvasLayer-HUD), `heal(amount)`.
- [x] **Layer:** neue Physics-Layer `enemy`, `enemy_hitbox`, `player_projectile`, `enemy_projectile`. Katana-Mask enthält `dummy` **und** `enemy`. Spieler-Wurfstern-Mask enthält `dummy` **und** `enemy`.
- [x] **Konstanten:** eine Quelle (`scripts/health.gd` oder eigenes `scripts/combat_constants.gd`). Tests `preload` dieselbe Quelle. Keine verdoppelten Magic Numbers in `tests/`.
- [x] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

## Automatisierte Tests

Headless-Pflicht (Merge-Gate, kein Fenster):

```bash
bash scripts/run-tests.sh
```

Äquivalent: `bash scripts/godot.sh --headless --path . -s tests/run_tests.gd`

Bestehende Stufe-1-Bewegungs- und Stufe-2-Kampftests in `tests/run_tests.gd` bleiben und bleiben grün (Dummy, J/K, Dodge, Tod, Combo-Guard).

Neu (Headless, ohne GdUnit). Konstanten per Preload derselben Klasse wie die Spiel-Logik (`Health` / `CombatConstants`, `Player`, `Dummy`, `ClanThug`, `ThrowFighter`, `Projectile`). Tests spawnen analog zu Stufe 2: World-Node, Boden, `request_*`, Physics-Frames.

| Test | Erwartung |
|------|-----------|
| Wurf bei 0 Munition | `request_throw` spawnt kein Projektil; Munition bleibt 0 |
| Wurf trifft Dummy | Munition sinkt um 1; Dummy-HP sinkt um `SHURIKEN_DAMAGE`; `SHURIKEN_DAMAGE < LIGHT_DAMAGE` |
| Ammo-Pickup | Pickup erhöht `shuriken_ammo` um `AMMO_PICKUP`, nicht über `MAX_AMMO` |
| Heal-Pickup | `heal` +`HEAL_PICKUP`; bei vollem Leben bleibt `MAX_HP`; kein Regen über Frames |
| Schläger jagt + sticht | Schläger bewegt sich zum Spieler; in Active-Frames `THUG_DAMAGE`; Dodge / `invulnerable` blockt |
| Wurfkämpfer-Projektil | Gegner-Wurfstern trifft Spieler um `THROWER_DAMAGE`; Dodge blockt |
| Interrupt | Treffer (Spieler-Wurfstern) während Wurfkämpfer-Telegraph → kein Gegner-Projektil |
| Tod bei 0 HP | Gegner `is_dead` (bzw. tot), keine weiteren Angriffe (Schläger sticht nicht, Wurfkämpfer wirft nicht) |
| Stufe 2 bleibt grün | Dummy-Swipe, Leicht/Schwer, Dodge-Block, Tod — unverändert |

Hilfen analog `_spawn_combat_player` / `_spawn_combat_dummy`: Szenen laden (`clan_thug.tscn`, `throw_fighter.tscn`, Pickups). Auto-Loop/Aggro für deterministische Tests abschaltbar (`auto_aggro = false` o. ä.) plus `request_stab` / `request_throw_attack` wie `Dummy.request_swipe`. Freeze-Frame in Headless skippen (bestehendes Hurtbox-Muster).

Projektil-Nachweis: Gruppe z. B. `player_projectile` / `enemy_projectile` oder Kind-Zählung unter der World-Node — nicht nach Hardcoded-Schadenszahl 6/10/15 suchen.

## In-Game-Checks

Visuelle In-Game-Checks nur auf ausdrücklichen User-Wunsch; sonst überspringen mit Begründung. Default ist die headless-Suite, kein Fensterspiel.

Start (nur wenn User Playtest verlangt): F5 in Godot, oder `bash scripts/godot.sh --path .` — kein Editor-Fokus stehlen.

- [ ] L wirft Stern in Blickrichtung; Ammo-Label aktualisiert sich
- [ ] Pickups auf dem Steg funktionieren (Ammo +3, Heal +30, Cap sichtbar)
- [ ] Schläger: Jagd + Stich lesbar (Telegraph-Farbe, dann Active)
- [ ] Wurfkämpfer: Telegraph, dann Wurf; Interrupt mit Spieler-Wurfstern während Telegraph
- [ ] Dummy bleibt Punching-Bag links (~x=300), unsterblich, Loop unverändert
- [ ] J/K treffen die neuen Gegner (Katana-Mask inkl. `enemy`)
- [x] Übersprungen, weil: kein ausdrücklicher User-Wunsch nach visuellem Playtest — Default ist headless, kein Godot-Editor, kein Fensterspiel, kein Fokus-Diebstahl.

### Playtest-Ergebnis (spiel-playtester)

- **Headless:** `bash scripts/run-tests.sh` — **40 passed, 0 failed** (Godot 4.7.2, `--headless`). Merge-Gate grün.
- **Visuell:** alle sechs In-Game-Checks übersprungen (siehe Skip-Zeile). Kein Fenster, kein Editor.
- **Merge-Blocker durch Playtest:** keiner. Visual-Skip blockiert Merge nicht (Default laut Workflow).

## Out of scope

- Pixel-Art für neue Elemente (keine neuen Sprites)
- Rauchbombe
- Fallenleger / Shuriken-Falle
- Boss / Hauptmann
- Checkpoint / Schrein
- HUD-Canvas (Stufe 6) — nur Greybox-Labels am Spieler
- Web-Export
- JUMP- / Dodge-Werte retunen
- Combokette ändern
- Dummy-Tod (Dummy bleibt unsterblich)

## Architektur

Bestehende Bausteine aus Stufe 2 weiterverwenden (`Health`, `Hitbox`, `Hurtbox`). Kein zweites Schadenssystem.

```
Player --L--> request_throw --ammo>0--> Shuriken (player_projectile)
         --mask dummy+enemy--> DummyHurtbox | EnemyHurtbox --> Health

Player --J/K--> Katana (player_hitbox)
         --mask dummy+enemy--> DummyHurtbox | EnemyHurtbox --> Health

ClanThug --chase--> telegraph --> stab (enemy_hitbox, mask player)
         --if not iframes--> PlayerHurtbox --> PlayerHealth

ThrowFighter --keep distance--> telegraph --> Shuriken (enemy_projectile)
         --mask player--> PlayerHurtbox
         --damage during telegraph--> cancel throw (no spawn)

Pickup --overlap player--> ammo += AMMO_PICKUP | heal(HEAL_PICKUP)
```

Neue Dateien:

| Datei | Rolle |
|-------|--------|
| `scripts/projectile.gd` | Bewegtes Projektil; Team/Schaden/Layer per Export; despawn bei Treffer oder Timeout |
| `scenes/shuriken.tscn` | `ColorRect`-Stern; dieselbe Szene für Spieler und Wurfkämpfer (Team/Layer/Schaden setzen) |
| `scripts/pickup.gd` | Overlap mit Spieler; Kind `ammo` / `heal`; einmalig, dann `queue_free` |
| `scenes/ammo_pickup.tscn` | Greybox-Pickup Munition |
| `scenes/heal_pickup.tscn` | Greybox-Pickup Heilung |
| `scripts/clan_thug.gd` | CharacterBody2D: Jagd, Telegraph, Stich; tot bei 0 HP |
| `scenes/clan_thug.tscn` | ColorRect-Körper, Health, Hurtbox, Hitbox |
| `scripts/throw_fighter.gd` | CharacterBody2D: Distanz halten, Telegraph, Wurf; Interrupt bei Schaden in Telegraph |
| `scenes/throw_fighter.tscn` | ColorRect-Körper, Health, Hurtbox (kein Nahkampf-Hitbox nötig) |

Bestehend erweitern:

- `scripts/player.gd` / `scenes/player.tscn` — `request_throw`, `shuriken_ammo`, Ammo-Label, `heal`; Input `throw` verdrahten; Katana-`collision_mask` um `enemy` erweitern
- `scripts/health.gd` — `heal(amount)` mit Cap `max_hp`; neue Kampf-Konstanten **oder** eigene `scripts/combat_constants.gd` (nur eine Quelle)
- `scenes/main.tscn` — Dummy-Position unverändert; Thug, Thrower, 1× Ammo, 1× Heal instanzieren
- `project.godot` — Layer-Namen 6–9

Empfohlene Layer (1-indexiert wie in `project.godot`; Stufe-2-Layer 1–5 unverändert):

| Layer | Name | Nutzung |
|-------|------|---------|
| 1 | `world` | StaticBody Greybox |
| 2 | `player` | Player-Body + Player-Hurtbox |
| 3 | `dummy` | Dummy-Body + Dummy-Hurtbox |
| 4 | `player_hitbox` | Katana; mask `dummy` **und** `enemy` |
| 5 | `dummy_hitbox` | Dummy-Swipe; mask `player` |
| 6 | `enemy` | Thug/Thrower-Body + Enemy-Hurtbox |
| 7 | `enemy_hitbox` | Thug-Stich; mask `player` |
| 8 | `player_projectile` | Spieler-Wurfstern; mask `dummy` **und** `enemy` |
| 9 | `enemy_projectile` | Wurfkämpfer-Stern; mask `player` |

Player-Body: layer `player`, mask `world`. Gegner-Body: layer `enemy`, mask `world`. Team-String auf Hitbox/Hurtbox (`player` / `dummy` / `enemy`), kein Selbst-Hit.

Dummy bleibt auf Layer `dummy` (nicht auf `enemy` umziehen) — sonst brechen Stufe-2-Tests und die Dummy-Mask.

## Benannte Konstanten (eine Quelle)

Schaden, HP, Munition, Heal in `scripts/health.gd` **oder** `scripts/combat_constants.gd` — nicht in beiden. Timing/Feel auf den Aktor-Skripten (`player.gd`, `projectile.gd`, `clan_thug.gd`, `throw_fighter.gd`), Tests preloaden diese Skripte.

Pflichtwerte (nicht stillschweigend ändern):

| Konstante | Wert | Bedeutung |
|-----------|------|-----------|
| `SHURIKEN_DAMAGE` | `6` | Spieler-Wurfstern; **muss** `< LIGHT_DAMAGE` (10) sein |
| `START_AMMO` | `5` | Spieler-Startmunition |
| `AMMO_PICKUP` | `3` | Ammo-Pickup |
| `MAX_AMMO` | `10` | Munitions-Cap |
| `SHURIKEN_SPEED` | `~420` | horizontale Geschwindigkeit; Feel darf ± leicht, Test trifft Dummy in wenigen Frames |
| `HEAL_PICKUP` | `30` | Heal-Pickup |
| `MAX_HP` | `100` | unverändert; Heal cappt hier; kein Regen |
| `THUG_DAMAGE` | `15` | Schläger-Stich |
| `THUG_MAX_HP` | `40` | Schläger stirbt bei 0 |
| `THROWER_DAMAGE` | `10` | Wurfkämpfer-Stern |
| `THROWER_MAX_HP` | `30` | Wurfkämpfer stirbt bei 0 |

Timing / Feel (Startwerte, benannt; tunen erlaubt, solange Tests über die Konstanten laufen):

| Konstante | Startwert | Bedeutung |
|-----------|-----------|-----------|
| `SHURIKEN_LIFETIME` | `1.2` s | Despawn, falls nichts getroffen |
| `THUG_SPEED` | `~150` | langsamer als Player `SPEED` (180), trotzdem Jagd |
| `THUG_STAB_RANGE` | `~48` px | kurze Stich-Reichweite |
| `THUG_TELEGRAPH` | `0.35` s | Farbe wie Dummy-Telegraph |
| `THUG_ACTIVE` | `0.12` s | kurze Active-Frames |
| `THUG_PAUSE` | `0.7` s | Pause vor nächster Jagd/Stich |
| `THROWER_SPEED` | `~140` | Repositionieren |
| `THROWER_PREFERRED_DISTANCE` | `~220` px | Abstand halten (Hysterese ok) |
| `THROWER_TELEGRAPH` | `0.45` s | sichtbar, dann erst spawn |
| `THROWER_THROW_RECOVERY` | `0.6` s | nach Wurf / nach Interrupt |

Dummy-Konstanten und Dummy-`immortal` unverändert.

## Platzierung in `scenes/main.tscn`

Spieler bleibt ~(160, 368). Dummy bleibt ~(300, 380). Vorschlag (Feel, Steg nach rechts; Zahlen dürfen leicht, Dummy-x nicht verschieben):

| Node | x (ungefähr) | Rolle |
|------|----------------|-------|
| Dummy | **300** | Punching-Bag, unverändert |
| AmmoPickup | ~480 | 1× Munition |
| ClanThug | ~720 | Jagd + Stich |
| HealPickup | ~900 | 1× Heilung |
| ThrowFighter | ~1100 | Distanz + Wurf |

Y auf Floor-Höhe (Dummy-Muster ~380 für Körper, Pickups auf dem Deck).

## Verbesserungsvorschläge (nicht im Pflicht-Scope)

Klar getrennt. Nur bauen, wenn der User zustimmt — sonst ignorieren.

- **Wurf-Recovery am Spieler** (z. B. `THROW_RECOVERY ~0.18` s), damit Munition nicht in fünf Frames leer ist. `just_pressed` begrenzt bereits auf einen Wurf pro Tastendruck; Recovery ist Feel, kein Blocker.
- **Katana-Interrupt:** Schaden allgemein (nicht nur Wurfstern) während Telegraph bricht den Wurf — empfohlen, weil `Health.damaged` schon existiert. Der Pflicht-Test bleibt der Wurfstern-Interrupt.

## Notizen für den Implementer

- `throw` ist in der Input Map bereits auf L (physical 76). Nur noch `Input.is_action_just_pressed("throw")` → `request_throw` verdrahten (nicht während `is_dead`).
- `request_throw`: blockieren bei Dodge und bei Heavy `WINDUP`/`ACTIVE` (`_heavy_rooted()`). Light und Recovery dürfen werfen. Luftwurf ok (kein Verbot). Bei `shuriken_ammo <= 0` return, kein Spawn.
- Nach erfolgreichem Wurf: `shuriken_ammo -= 1`, Label updaten, `shuriken.tscn` instanzieren, Position vor dem Spieler, Velocity `facing * SHURIKEN_SPEED`, `y`-Velocity 0.
- Ammo-Label: `Label`-Kind am Player wie `HpLabel`, Greybox, kein `CanvasLayer`. Text aus `shuriken_ammo`.
- `Health.heal(amount)`: `amount <= 0` ignorieren; `current = mini(current + amount, max_hp)`; tot (`current == 0` und nicht immortal) nicht wiederbeleben, sofern nicht ausdrücklich nötig — Pickups liegen vor dem Tod. Player.heal delegiert und updated Labels.
- Projektil: Hitbox-Logik wiederverwenden (Team + `receive_hit`), bei `landed` despawnen. Spieler-Stern: layer `player_projectile`, mask dummy+enemy, damage `SHURIKEN_DAMAGE`, team `player`. Wurfkämpfer: dieselbe Szene, layer `enemy_projectile`, mask player, damage `THROWER_DAMAGE`, team `enemy`.
- Schläger/Wurfkämpfer: `Health` ohne `immortal`; `died` → `is_dead`, Bewegung und Angriffe aus, Hitbox aus. Hurtbox respektiert `is_dead` bereits.
- Telegraph-Farbe an Dummy anlehnen (`COLOR_TELEGRAPH` / Active-Rot), damit Muster lesbar sind.
- Wurfkämpfer-Interrupt: in Phase Telegraph bei `Health.damaged` → Phase abbrechen, kein Spawn. Bereits geflogene Sterne nicht zurückziehen.
- Distanz: wenn Spieler näher als Preferred → weg; weiter → ran; in Band → Telegraph wenn bereit. Tests dürfen `request_throw_attack` erzwingen.
- Katana: in `player.gd` ist `collision_mask` derzeit nur Dummy (`4`). Mask um Enemy-Bit erweitern, sonst treffen J/K die neuen Gegner nicht. Dummy-Layer nicht entfernen.
- Dummy nicht auf Enemy-Layer schieben, nicht töten, Loop nicht umbauen.
- Bewegung/Jump/Dodge/Combo-Zahlen nicht anfassen.
- Tests: `HealthGD.SHURIKEN_DAMAGE` usw. preloaden — nie `6`, `15`, `30` als Literale in Erwartungen, außer wo unvermeidbar in Szenen-Koordinaten.
- Headless: `DisplayServer.get_name() == "headless"` für Shake/Freeze wie bisher.
- Eine Slice, keine weiteren Dateien außer den Pflicht-Neuen plus optional genau einer Konstanten-Datei.
