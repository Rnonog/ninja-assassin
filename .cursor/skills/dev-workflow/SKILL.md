---
name: dev-workflow
description: Orchestrates Ninja Assassin work for new features, bugfixes, and improvements. Use when the user asks for a feature, Funktion, Bugfix, Fehlerbehebung, or Verbesserung; enforces plan mode, slices under docs/plans, subagents, tests, and GitHub main.
---

# Entwicklungsprozess

Parent-Agent orchestriert. Implementierung nur nach User-Freigabe der Plan-Dateien.

Vor jeder Code-Änderung: Skill `git-trunk` (eigener Worktree).

## Feature oder neue Funktion

1. `SwitchMode` → `plan`. Kein Implementieren ohne Plan-Datei.
2. Unklarheiten: `AskQuestion` falls verfügbar, sonst im Parent-Chat (Ziel, Metrik, Scope). Verbesserungsvorschläge einbringen und prüfen, ob sie so gewollt sind.
3. Subagent `task-slicer` → `docs/plans/<aufgabe>/INDEX.md` + Stubs. Mini-Scope = 1 Slice.
4. Subagent `feature-planner` → Slice-Dateien füllen (Pflicht bei Features).
5. User-Freigabe abwarten.
6. Subagent `feature-implementer` (nur freigegebener Slice, inkl. Tests).
7. Subagent `code-reviewer`. Criticals fixen, bevor Playtest.
8. Subagent `spiel-playtester` (Verhalten im laufenden Spiel).
9. Automatisierte Regressionstests und In-Game-Checks laut Slice.

## Bugfix / Fehlerbehebung

1. Subagent `task-slicer` → `docs/plans/<aufgabe>/INDEX.md` + Bug-Stub.
2. Phase 0 Pflicht: Subagent `bug-investigator` — Reproduzieren → Root-Cause → dokumentieren in Slice/Bug-Dokument. Kein Fix in Phase 0. Kein Blind-Fix.
3. Failing Regressionstest zuerst, dann `feature-implementer` (Fix), dann `code-reviewer`.
4. Retest: Suite + `spiel-playtester`.

## Verbesserung

1. Unklare Anfrage: `AskQuestion` falls verfügbar, sonst im Parent-Chat (Ziel, Metrik, Scope).
2. Subagent `task-slicer` → INDEX + Stub. Mini-Scope = 1 Slice.
3. Ist-Zustand im laufenden Spiel oder per Test nachweisen (Baseline).
4. Subagent `feature-planner` füllt den Slice. User-Freigabe abwarten.
5. `feature-implementer` → `code-reviewer` → Criticals fixen → `spiel-playtester`.
6. Regressionstests für das verbesserte Verhalten.

## Subagents und Skills

| Phase | Subagent | Skill |
|-------|----------|-------|
| Slicing | `task-slicer` | `task-slicer` |
| Feature-Plan | `feature-planner` | `feature-planner` |
| Bug Phase 0 | `bug-investigator` | `bug-investigator` |
| Implementierung | `feature-implementer` | `feature-implementer` |
| Review | `code-reviewer` | `code-reviewer` |
| Playtest | `spiel-playtester` | `spiel-playtester` |
| Git | Parent | `git-trunk` |

Templates: `docs/plans/_templates/`.
