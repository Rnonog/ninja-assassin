---
name: feature-planner
description: Fills feature slice files under docs/plans with goals, acceptance criteria, automated tests, and in-game checks. Mandatory for features after task-slicer; use before user approval.
disable-model-invocation: true
---

# Feature Planner

Füllt Slice-Dateien. Kein Code. Pflicht bei Features nach `task-slicer`.

## Vorgehen

1. `docs/plans/<aufgabe>/INDEX.md` und Stubs lesen.
2. Jede Slice-Datei vollständig ausfüllen (Template `SLICE.md`):
   - Ziel des Slices
   - Akzeptanzkriterien (prüfbar)
   - Automatisierte Regressionstests
   - In-Game-Checks (Verhalten im laufenden Spiel)
   - Out-of-scope
3. INDEX aktualisieren (Slice-Status: `geplant` = bereit zur User-Freigabe).
4. Verbesserungsvorschläge als eigene, klar markierte Abschnitte — nicht stillschweigend einbauen.
5. User-Freigabe ist Sache des Parent-Agents, nicht dieses Skills.

## Nicht tun

- Implementieren
- Slices ohne User-OK mergen oder streichen
- Scope still erweitern
