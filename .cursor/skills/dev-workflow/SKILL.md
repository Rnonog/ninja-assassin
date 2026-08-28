---
name: dev-workflow
description: Orchestrates Ninja Assassin work for new features, bugfixes, and improvements. Use when the user asks for a feature, Funktion, Bugfix, Fehlerbehebung, or Verbesserung; enforces plan mode, slices under docs/plans, subagents, tests, and GitHub main.
---

# Entwicklungsprozess

Parent-Agent orchestriert. Rollen leben in `.cursor/agents/` (keine extra Skill je Rolle). Git: Skill `git-trunk`. Vor jeder Code-Änderung Worktree laut `git-trunk`.

Implementierung nur nach User-Freigabe der Plan-Dateien unter `docs/plans/<aufgabe>/`.

## Feature oder neue Funktion

1. `SwitchMode` → `plan`. Kein Implementieren ohne Plan-Datei.
2. Unklarheiten: `AskQuestion` falls verfügbar, sonst im Parent-Chat (Ziel, Metrik, Scope). Verbesserungsvorschläge einbringen und prüfen, ob sie so gewollt sind.
3. Subagent `task-slicer` → `docs/plans/<aufgabe>/INDEX.md` + Stubs. Mini-Scope = 1 Slice.
4. Subagent `feature-planner` → Slice-Dateien füllen (Pflicht bei Features).
5. User-Freigabe abwarten.
6. Subagent `feature-implementer` (nur freigegebener Slice, inkl. headless-Tests `bash scripts/run-tests.sh`; kein Godot-Fenster).
7. Parent startet Subagent `code-reviewer` mit `run_in_background: true`: Plan so umgesetzt wie gewollt? Struktur, Modularisierung, Best Practices. Keine Warteschleife im Parent-Chat. User kann weiterarbeiten; Parent wird benachrichtigt, wenn der Reviewer fertig ist. Criticals fixen.
8. Merge-Gate: `bash scripts/run-tests.sh` (Godot `--headless`). Niemals ein Godot-Fenster für die Suite. Headless-Suite ist Pflicht.
9. `spiel-playtester` ist kein blockierender Fenster-Durchlauf per Default: kein Godot-Editor, kein Fensterspiel, kein Fokus-Diebstahl. Visuelle In-Game-Checks nur, wenn der User sie ausdrücklich verlangt; sonst Playtest überspringen und den Grund festhalten. Falls `spiel-playtester` überhaupt gestartet wird: ebenfalls `run_in_background: true` (Hintergrund).

## Bugfix / Fehlerbehebung

1. Subagent `task-slicer` → INDEX + Bug-Stub.
2. Phase 0: Subagent `bug-investigator` — Repro, Root-Cause, Doku. Kein Fix in Phase 0. Kein Blind-Fix.
3. Failing Regressionstest zuerst, dann `feature-implementer` (headless `scripts/run-tests.sh`), dann Parent startet `code-reviewer` mit `run_in_background: true` (Plan-Treue, Struktur, Modularisierung, Best Practices). Keine Warteschleife.
4. Retest: headless-Suite `bash scripts/run-tests.sh` (kein Godot-Fenster). `spiel-playtester` visuell nur auf ausdrücklichen Wunsch, sonst Skip mit Grund; falls gestartet: `run_in_background: true` im Hintergrund.

## Verbesserung

1. Unklare Anfrage: `AskQuestion` falls verfügbar, sonst im Parent-Chat (Ziel, Metrik, Scope).
2. Subagent `task-slicer` → INDEX + Stub. Mini-Scope = 1 Slice.
3. Ist-Zustand per Test nachweisen (Baseline; im laufenden Spiel nur auf ausdrücklichen Wunsch).
4. Subagent `feature-planner` füllt den Slice. User-Freigabe abwarten.
5. `feature-implementer` (headless `scripts/run-tests.sh`), dann Parent startet `code-reviewer` mit `run_in_background: true` (Plan-Treue, Struktur, Modularisierung, Best Practices). Criticals fixen. Keine Warteschleife.
6. Regressionstests headless (`bash scripts/run-tests.sh`). Visuelles Playtest nur auf ausdrücklichen Wunsch, sonst Skip mit Grund. Falls `spiel-playtester`: `run_in_background: true` (Hintergrund).

Templates: `docs/plans/_templates/`.

## Mehrphasige Vorhaben

Wenn ein Vorhaben mehrere Phasen oder Stufen hat (z. B. MVP in KONZEPT §12.1):

1. Im **übergeordneten Plan** eine Fortschrittstabelle führen (Phase, Plan-Ordner, Status).
2. Status: `offen` | `in Umsetzung` | `erledigt`.
3. Beim Start einer Phase: Status auf `in Umsetzung` setzen.
4. Nach Abschluss (headless-Tests grün, Review, Push; visuelles Playtest nur auf Wunsch): Status auf `erledigt` setzen, **bevor** die nächste Phase beginnt.
5. Dieselbe Markierung in allen Kopien des Plans halten: `docs/plans/`, Konzept-Roadmap, Cursor-Plan, Canvas.

Nicht umgesetzte Phasen bleiben sichtbar als `offen`. Keine Phase als erledigt markieren, nur weil Code existiert — erst nach Tests, Review und Push (visuelles Playtest nur auf Wunsch).
