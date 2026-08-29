# Slice: Hauptmann, Arena, Sieg/Niederlage

**Aufgabe:** `docs/plans/mvp-boss/`
**Status:** implementiert
**Slice-ID:** `01-boss-arena`
**KONZEPT:** §12.1 Stufe 5 (ohne Intro/Pause)

## Ziel

Hauptmann in der bestehenden Arena. Eintritt schließt Wände, Stampf mit Telegraph, Boss-HP-Balken. Sieg nur wenn Boss tot und Exit. Tod mit lebendem Boss: Overlay, Respawn am letzten Schrein, Arena-Reset. Zweiter Schrein vor der Arena.

## Akzeptanzkriterien

- [x] `scripts/clan_captain.gd` + `scenes/clan_captain.tscn`: Chase → Telegraph → Stampf-AoE → Pause. `Health.BOSS_MAX_HP` > `THUG_MAX_HP`, `BOSS_STOMP_DAMAGE` ~25. Collision größer als 24×40. `JUMP_VELOCITY` unverändert.
- [x] `scripts/arena_controller.gd`: Enter ~x=3480 lockt beide Wände; nach Boss-Tod nur rechte Wand weg. Links bleibt zu.
- [x] Tod bei lebendem Boss: Niederlage-Overlay, dann `RunSession`-Respawn; Arena-Reset (Wände auf, Boss voll).
- [x] Sieg: Boss tot **und** Exit-Overlap → Overlay, Spieler eingefroren, gleiche Instanz, kein Scene-Reload. Exit allein ohne toten Boss kein Sieg.
- [x] Zweiter Schrein zwischen Supply und Arena. `RunSession` verbindet **alle** `checkpoint`.
- [x] Boss-HP-Balken CanvasLayer nur während Lock und Boss lebt. Kein Spieler-HUD. Kein ColorRect in `level_greybox.tscn`.
- [x] Intro und Pause nicht in diesem Slice.
- [x] Automatisierte Regressionstests decken das neue Verhalten
- [x] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

## Automatisierte Tests

Headless: `bash scripts/run-tests.sh`

- Zweiter Schrein überschreibt Spawn/Munition
- Arena-Enter aktiviert Wände; Weg nach links blockiert
- Stampf nach Telegraph trifft; Dodge-i-Frames blocken
- Boss 0 HP → rechte Wand weg; Exit ohne tot kein Sieg; Exit danach Sieg
- Tod bei lebendem Boss → Respawn am Schrein, Boss wieder `BOSS_MAX_HP`, Wände offen
- Stufe 1–4 + Contrast grün; `main_boot`; `level_no_colorrect_visuals`

## In-Game-Checks

Visuelle Checks nur auf ausdrücklichen Wunsch; sonst Skip.

- [x] Übersprungen, weil: kein ausdrücklicher User-Wunsch nach visuellem Playtest

## Out of scope

- Intro, Pause, Pixel-Art, Spieler-HUD, Audio

## Notizen für den Implementer

- `RunSession` darf nicht nur `get_first_node_in_group("checkpoint")` binden.
- Arena-Reset bei Spieler-Respawn, nicht sofort beim Tod (sonst Wände weg bevor Overlay).
- Trash Zone 1/2 bleibt tot.
