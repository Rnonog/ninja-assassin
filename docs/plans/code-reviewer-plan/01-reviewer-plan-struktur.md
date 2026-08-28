# Slice: Reviewer auf Plan und Struktur

**Aufgabe:** `docs/plans/code-reviewer-plan/`
**Status:** erledigt

## Ziel

Nach `feature-implementer` verifiziert `code-reviewer` die Umsetzung gegen den Slice und die Qualität der Struktur.

## Akzeptanzkriterien

- [x] Agent prüft jedes Slice-Akzeptanzkriterium (Met / Not met / N/A)
- [x] Agent prüft Modularisierung und sinnvolle Datei-/Modulgrenzen
- [x] Agent prüft Best Practices (Tests, Naming, keine Secrets, Godot-Konventionen wenn Spielcode)
- [x] Criticals bleiben Pflicht vor `spiel-playtester`
- [x] In-Game-Checks begründet übersprungen

## Automatisierte Tests

- `bash scripts/check-dev-workflow.sh` bleibt grün (Agent-Datei existiert, keine Rollen-Skill)

## In-Game-Checks

- [x] Übersprungen, weil: kein Spielcode

## Out of scope

- Playtester oder Implementer ändern
