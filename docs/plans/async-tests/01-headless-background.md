# Slice: Headless-Suite und Background-Review

**Aufgabe:** `docs/plans/async-tests/`
**Status:** implementiert

## Ziel

Review und Tests laufen im Hintergrund. Der Parent-Chat bleibt frei und benachrichtigt, wenn sie fertig sind. Die automatisierte Suite bleibt Pflicht-Gate, läuft aber nur headless (`scripts/run-tests.sh`). Visuelles Playtest (Godot-Editor oder Spielfenster) nur, wenn der User es ausdrücklich verlangt; sonst übersprungen mit Begründung. Kein Fokus-Diebstahl.

## Ist-Zustand (Baseline)

- `scripts/run-tests.sh` startet Godot bereits mit `--headless` (`scripts/godot.sh --headless --path … -s tests/run_tests.gd`). Die Suite selbst öffnet kein Fenster.
- `spiel-playtester.md` fordert heute: Spiel starten (Godot-Editor, Export oder Dev-Befehl) und Checks als Spieler durchspielen — das stiehlt Bildschirm/Fokus.
- Parent wartet sequentiell: `feature-implementer` → `code-reviewer` → `spiel-playtester` (kein `run_in_background`).
- `feature-implementer.md` erwähnt `scripts/run-tests.sh` nicht und verbietet bereits `spiel-playtester` (das bleibt).

## Akzeptanzkriterien

Parent-Orchestration (Skill + Regel, gleiche Semantik):

- [ ] Nach `feature-implementer` startet der Parent `code-reviewer` mit `run_in_background: true`. Keine Warteschleife im Parent-Chat. User kann weiterarbeiten; Parent wird benachrichtigt, wenn der Reviewer fertig ist.
- [ ] Automatisiertes Gate vor Merge: `bash scripts/run-tests.sh` (bereits Godot `--headless`). Niemals ein Godot-Fenster für die Suite starten. Headless-Suite ist Pflicht.
- [ ] `spiel-playtester` ist kein blockierender Fenster-Durchlauf per Default. Default: kein Godot-Editor, kein Fensterspiel, kein Fokus-Diebstahl.
- [ ] Visuelle In-Game-Checks nur, wenn der User sie ausdrücklich verlangt. Sonst Playtest überspringen und den Grund festhalten (kein ausdrücklicher Wunsch / kein Spielcode).
- [ ] Falls `spiel-playtester` überhaupt gestartet wird: ebenfalls `run_in_background: true`, Parent nicht blockieren.

`spiel-playtester.md`:

- [ ] Startet Godot-Editor oder ein Fensterspiel **nicht**, außer der User hat visuelles Playtest ausdrücklich verlangt.
- [ ] Bevorzugt Headless-Suite-Ergebnisse dokumentieren/bestätigen (`scripts/run-tests.sh`); kein interaktives Durchspielen als blockierende Session.
- [ ] Ohne Spielcode: In-Game überspringen mit Begründung (bestehende Regel bleibt).
- [ ] Stiehlt niemals Fensterfokus.
- [ ] Der alte Default-Schritt „Start the game (Godot editor, export, or documented dev command)“ ist kein unbedingter Pflichtschritt mehr.

`feature-implementer.md`:

- [ ] Führt automatisierte Tests über `scripts/run-tests.sh` (headless) aus.
- [ ] Startet kein Godot-Fenster.
- [ ] Startet nicht `spiel-playtester` (bestehende Regel bleibt).

Templates:

- [ ] `docs/plans/_templates/SLICE.md`: Automatisierte Tests = Headless-Pflicht (`scripts/run-tests.sh`). In-Game-Checks visuell = optional, nur auf ausdrücklichen User-Wunsch; sonst überspringen mit Begründung.
- [ ] `docs/plans/_templates/BUG.md` Retest: Suite headless Pflicht (`scripts/run-tests.sh`); `spiel-playtester` visuell nur auf Wunsch.

`docs/plans/README.md`:

- [ ] Kurzer Hinweis: Gate ist headless; visuelles Playtest nur auf Wunsch; Reviewer/Playtester im Hintergrund (`run_in_background`).

`scripts/check-dev-workflow.sh`:

- [ ] Skill `dev-workflow` und Regel `dev-workflow.mdc` müssen `run_in_background` und/oder `Hintergrund` **und** `headless` erwähnen (sonst FAIL).
- [ ] `spiel-playtester.md` muss die neue Policy enthalten (kein Fensterspiel per Default; visuell nur auf ausdrücklichen Wunsch; headless bevorzugen; kein Fokus-Diebstahl). Grep auf die neue Policy, nicht auf den alten „Start the game“-Default.
- [ ] Plan-Templates-Checks um `docs/plans/async-tests/INDEX.md` und `docs/plans/async-tests/01-headless-background.md` ergänzt (wie bei `dev-workflow` und `slim-workflow`).
- [ ] `bash scripts/check-dev-workflow.sh` ist grün.

- [ ] Automatisierte Regressionstests decken das neue Verhalten (`check-dev-workflow.sh` plus Headless-Gate `run-tests.sh`)
- [ ] In-Game-Checks (unten) sind ausgeführt oder begründet übersprungen

## Automatisierte Tests

Headless-Pflicht (Merge-Gate, kein Fenster):

- `bash scripts/run-tests.sh`
- Godot nur `--headless`. Kein Editor, kein Spielfenster.

Slice-Regression (Prozess-Texte):

- `bash scripts/check-dev-workflow.sh`
- Neue Checks wie in den Akzeptanzkriterien: Skill + Regel (`run_in_background`/`Hintergrund` und `headless`); Playtester-Policy; Plan-Dateien `async-tests`.

Befehl zum Ausführen: zuerst `bash scripts/check-dev-workflow.sh`, vor Merge zusätzlich `bash scripts/run-tests.sh`.

## In-Game-Checks

Visuelles Playtest ist in diesem Slice **nicht** verlangt (User hat kein visuelles Playtest ausdrücklich gewünscht; Slice ändert nur Prozess-/Doku-Dateien, keinen Spielcode).

- [x] Übersprungen, weil: kein Spielcode in diesem Slice und kein ausdrücklicher User-Wunsch nach visuellem Playtest. Headless-Suite bleibt das Gate.

## Out of scope

- Godot-/Gameplay-Code ändern
- Physik-Tests / GdUnit umschreiben
- Subagents zusammenlegen
- git-trunk ändern
- visuelles Playtest zur Pflicht machen
- `code-reviewer.md` umschreiben (Background-Start ist Parent-Orchestration in Skill/Regel)

## Notizen für den Implementer

Keine stillen Scope-Erweiterungen. Nur die Dateien aus INDEX-Scope anfassen.

**Regel + Skill** (deutsch, gleiche Semantik in beiden): Feature-/Bug-/Verbesserung-Schritte so umschreiben, dass nach dem Implementer der Reviewer mit `run_in_background: true` startet; Headless-Suite `scripts/run-tests.sh` Pflicht; visuelles Playtest nur auf ausdrücklichen Wunsch; sonst Skip mit Grund. Formulierung „Verhalten im laufenden Spiel“ als Default-Pflicht entfernen oder an die Opt-in-Regel koppeln.

**spiel-playtester.md** (englisch wie bisher): When-invoked-Schritte ersetzen. Default-Pfad: Slice lesen, Headless-Ergebnis bestätigen/dokumentieren, visuelle Checks nur bei ausdrücklichem User-Wunsch ausführen, sonst Skip mit Begründung. Nie Editor/Fenster/Fokus.

**feature-implementer.md:** Nach Slice-Code explizit `bash scripts/run-tests.sh` (headless). Kein Godot-Fenster. Weiterhin kein `spiel-playtester`.

**check-dev-workflow.sh:** Neue Sektion analog zu „Mehrphasiger Fortschritt“. Plan-Dateien analog zu `docs/plans/slim-workflow/…` eintragen.

Freigabe-Checkboxen im INDEX nicht selbst anhaken.
