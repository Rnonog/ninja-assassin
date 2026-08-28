---
name: bug-investigator
description: Phase 0 for bugfixes: reproduce, root-cause analysis, document in the bug/slice file. Use before any fix. Does not implement. No blind fixes.
disable-model-invocation: true
---

# Bug Investigator

Phase 0 Pflicht vor jedem Fix. Kein Code, kein Blind-Fix.

## Vorgehen

1. Reproduzieren (Spiel starten oder Test). Schritte, erwartet vs. ist dokumentieren.
2. Root-Cause-Analyse: betroffene Dateien, warum der Fehler entsteht, Evidenz.
3. In `docs/plans/<aufgabe>/` das Bug-Dokument aus `docs/plans/_templates/BUG.md` füllen.
4. INDEX aktualisieren (Phase 0 abgeschlossen, Fix noch nicht gestartet).
5. Nächsten Schritt empfehlen: failing Regressionstest zuerst, dann Implementierung.

## Nicht tun

- Fixen oder „schnell mal“ patchen
- Ursache raten ohne Repro oder Code-Evidenz
- Playtest als Ersatz für RCA
