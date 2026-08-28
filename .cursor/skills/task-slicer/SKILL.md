---
name: task-slicer
description: Splits a Ninja Assassin task into slices and writes docs/plans/<aufgabe>/INDEX.md plus stub files. Use before feature-planner when starting a feature, bug, or improvement.
disable-model-invocation: true
---

# Task Slicer

Zerlegt eine Aufgabe in umsetzbare Slices. Schreibt Dateien, implementiert keinen Code.

## Vorgehen

1. Aufgabe benennen: kebab-case-Ordner `docs/plans/<aufgabe>/`.
2. Templates kopieren: `docs/plans/_templates/INDEX.md` → `INDEX.md`.
3. Pro Slice eine Stub-Datei aus `docs/plans/_templates/SLICE.md` (Features/Verbesserungen) oder `BUG.md` (Bugs).
4. Mini-Scope: **ein Slice reicht** — kein künstliches Splitting.
5. INDEX ausfüllen: Ziel, Metrik, Scope, Out-of-scope, Slice-Liste, Worktree `task/<slug>`, Freigabe noch offen.

## Stub-Namen

`01-<kurzname>.md`, bei Bedarf `02-…`. Jeder Stub hat Titel und leere Abschnitte; Inhalt füllt `feature-planner` bzw. `bug-investigator`.

## Output

- `docs/plans/<aufgabe>/INDEX.md`
- `docs/plans/<aufgabe>/01-….md` (mindestens eine Datei)
- Kurze Zusammenfassung an den Parent: Slice-Anzahl, Pfade, offene Fragen
