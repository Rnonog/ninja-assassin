# Ninja Assassin — Konzeptdokument

**Version:** 1.0  
**Datum:** 28. August 2026  
**Sprache:** Deutsch  
**Projekt:** [ninja-assassin](https://github.com/Rnonog/ninja-assassin)

---

## 1. Elevator Pitch

*Ninja Assassin* ist ein taktisches Stealth-Action-Spiel aus der Vogelperspektive. Der Spieler schlüpft in die Rolle eines namenlosen Shinobi, der feindliche Festungen infiltriert, Wachen ausmanövriert und hochrangige Ziele lautlos eliminiert. Präzision, Geduld und Planung werden belohnt — Lautstärke und Hektik bestraft.

> **Kurzform:** Schleiche durch Schatten, eliminiere dein Ziel, verschwinde spurlos.

---

## 2. Spielvision

### 2.1 Kernfantasie

Der Spieler fühlt sich wie ein Meister-Assassine: unsichtbar, tödlich und immer einen Schritt voraus. Jeder Raum ist ein Puzzle aus Sichtlinien, Geräuschen und Timing.

### 2.2 Zielgruppe

- Fans von Stealth-Spielen (*Mark of the Ninja*, *Stealth Inc.*, *Hotline Miami* im Planungsmodus)
- Gelegenheitsspieler, die kurze, intensive Missionen bevorzugen
- Altersempfehlung: **12+** (stilisierte Gewalt, keine explizite Brutalität)

### 2.3 Alleinstellungsmerkmale (USP)

| Merkmal | Beschreibung |
|---------|--------------|
| **Schatten-System** | Sichtbarkeit hängt von Licht und Deckung ab — kein reiner „Unsichtbarkeitsmodus“ |
| **Geräusch-Feedback** | Jede Aktion erzeugt Lautstärke; Wachen reagieren dynamisch |
| **Ghost-Rating** | Missionen werden nach Entdeckung, Körpern und Zeit bewertet |
| **Minimalistische Ästhetik** | Klare Silhouetten, starke Kontraste — Gameplay steht im Vordergrund |

---

## 3. Spielprinzip & Ziel

### 3.1 Hauptziel

Infiltriere feindliche Anwesen, erreiche das **Primärziel** (Hauptmann, Daimyo, Spion) und entkomme ungesehen über den **Exfiltrationspunkt**.

### 3.2 Siegbedingungen

- Primärziel eliminiert oder entführt (missionsabhängig)
- Spieler erreicht Exfiltrationszone
- Optional: Sekundärziele erfüllt (Dokumente, Sabotage)

### 3.3 Niederlagebedingungen

- Spieler stirbt (0 Trefferpunkte)
- Alarmstufe **ROT** für mehr als 10 Sekunden ohne Flucht
- Zeitlimit abgelaufen (nur in bestimmten Missionen)

---

## 4. Spielmechaniken

### 4.1 Bewegung

- **Gehen:** Lautlos, langsam
- **Rennen:** Schnell, erzeugt hohe Geräuschkulisse
- **Kriechen:** Sehr langsam, nahezu lautlos, reduzierte Sichtbarkeit
- **Klettern:** An Wänden und Vorsprüngen entlang (nur markierte Routen)

### 4.2 Kampf & Eliminierung

| Aktion | Wirkung | Risiko |
|--------|---------|--------|
| **Lautlose Eliminierung** (Nähe, von hinten) | Sofortiger Kill | Gering, wenn unentdeckt |
| **Wurfwaffe** (Shuriken, Kunai) | Betäubt oder tötet aus Distanz | Mittel — verfehlte Würfe machen Lärm |
| **Rauchbombe** | Blockiert Sichtlinie kurzzeitig | Gering — Ablenkung, kein Kill |
| **Offener Kampf** (Katana) | Schneller Kill | Hoch — Alarm fast garantiert |

### 4.3 Sicht & Schatten

- **Sichtkegel** der Wachen sind sichtbar (optional abschaltbar für Hardcore-Modus)
- **Lichtzonen:** Hell = leicht entdeckbar, Schatten = schwer entdeckbar
- **Deckung:** Objekte blockieren Sichtlinien vollständig

### 4.4 Geräuschsystem

Jede Aktion erzeugt **Lautstärke-Punkte** in einem Radius:

```
Gehen:     ░░░░░  (5 m)
Rennen:    ░░░░░░░░░░  (15 m)
Kampf:     ░░░░░░░░░░░░░░  (25 m)
Leiche:    ░░░░░░░░░  (12 m — wenn entdeckt)
```

Wachen untersuchen Geräuschquellen und kehren nach Timeout zum Patrouillen zurück.

### 4.5 Alarmstufen

| Stufe | Name | Verhalten der Wachen |
|-------|------|---------------------|
| 0 | **Grün** | Normale Patrouille |
| 1 | **Gelb** | Erhöhte Wachsamkeit, erweiterte Sichtkegel |
| 2 | **Rot** | Aktive Suche, Verstärkung wird gerufen |

---

## 5. Progression & Meta-Game

### 5.1 Missionen

- **Kampagne:** 12 handgefertigte Missionen in 3 Akten
  - *Akt I — Lehrling:* Einfache Infiltration, Tutorial-Mechaniken
  - *Akt II — Schatten:* Komplexere Level, mehr Wachen, Sekundärziele
  - *Akt III — Meister:* Enge Zeitlimits, mehrere Primärziele

### 5.2 Ghost-Rating (pro Mission)

| Rang | Bedingung |
|------|-----------|
| **S** | Keine Entdeckung, 0 Leichen sichtbar, unter Par-Zeit |
| **A** | Max. 1 Entdeckung, alle Leichen versteckt |
| **B** | Mission abgeschlossen, Alarm ausgelöst |
| **C** | Mission abgeschlossen mit hohem Risiko / vielen Kills |

### 5.3 Freischaltbare Ausrüstung

- Shuriken (Standard)
- Rauchbombe (Mission 3)
- Hakenseil (Mission 5)
- Betäubungspfeil (Mission 8)
- Doppel-Katana (New Game+, alle S-Ränge)

---

## 6. Level-Design

### 6.1 Struktur eines Levels

```
[Einstieg] → [Patrouillenzone] → [Schlüsselraum] → [Zielraum] → [Exfiltration]
                  ↓
           [Sekundärziel / Geheimweg]
```

### 6.2 Designprinzipien

1. **Mehrere Lösungswege:** Laut, leise, Ablenkung, Umweg
2. **Lesbarkeit:** Spieler erkennt Sichtlinien und Deckung auf einen Blick
3. **Keine Dead Ends:** Jeder Raum hat mindestens zwei Ein-/Ausgänge
4. **Belohnung für Erkundung:** Geheime Pfade, versteckte Ausrüstung

### 6.3 Beispiel-Mission: „Der Tempel des Verrats“

- **Setting:** Japanisches Bergkloster bei Nacht
- **Primärziel:** Korrupten Mönch eliminieren
- **Sekundärziel:** Beweisdokumente stehlen
- **Besonderheit:** Glöckchen-Wachen — bewegungsempfindlich
- **Par-Zeit:** 4:30 Minuten

---

## 7. Gegner & KI

### 7.1 Wachtypen

| Typ | Verhalten | Schwäche |
|-----|-----------|----------|
| **Patrouille** | Feste Route, langsamer Sichtkegel | Ablenkung von hinten |
| **Wachposten** | Steht still, breiter Sichtkegel | Große Lücke im Kegel |
| **Elite-Wache** | Reagiert schneller auf Geräusche | Kein Rücken-Kill bei voller Aufmerksamkeit |
| **Glöckchen-Wache** | Alarm bei Bewegung in Radius | Nur aus großer Distanz ausschalten |
| **Bogenschütze** | Fernkampf, hohe Position | Kein Nahkampf |

### 7.2 KI-Zustandsautomat

```
Patrouillieren → Verdacht → Untersuchen → Alarm → Suchen → Patrouillieren
```

---

## 8. Steuerung

### 8.1 Tastatur & Maus (PC)

| Taste | Aktion |
|-------|--------|
| WASD | Bewegung |
| Shift | Rennen |
| Strg | Kriechen |
| Leertaste | Interagieren / Eliminieren |
| Q | Wurfwaffe |
| E | Ausrüstung (Rauch, Seil) |
| R | Leiche verstecken |
| Tab | Sichtkegel ein/aus |

### 8.2 Touch / Gamepad

- Linker Stick: Bewegung
- A / X: Interagieren
- B / Kreis: Wurfwaffe
- L2 / LT: Kriechen

---

## 9. Visueller Stil

### 9.1 Art Direction

- **Perspektive:** Top-Down / leicht isometrisch (45°)
- **Farbpalette:** Dunkle Blau-/Schwarztöne, Akzentfarbe Rot (Blut, Alarm), Gold (Ziele)
- **Charaktere:** Silhouetten-Stil — wenig Detail, starke Lesbarkeit
- **Umgebung:** Japanisches Feudal-Setting — Tempel, Festungen, Bambuswälder

### 9.2 UI / HUD

- Minimalistisch: Geräusch-Meter, Alarmstufen-Anzeige, Ziel-Marker
- Kein permanenter Minimap — optional einklappbar
- Ghost-Rating am Missionsende als animierte Zusammenfassung

---

## 10. Audio

| Kategorie | Beschreibung |
|-----------|--------------|
| **Musik** | Ambient, Shamisen & Taiko, dynamisch bei Alarm |
| **SFX** | Betonung auf Schritte, Waffen, Wachen-Reaktionen |
| **Feedback** | Subtiler Herzschlag bei hoher Entdeckungsgefahr |

---

## 11. Technischer Scope (MVP)

### 11.1 Plattform

- **Web** (Browser, Desktop & Mobile) — primäres Ziel
- Optional später: Steam / Desktop-Export

### 11.2 Tech-Stack (Vorschlag)

- **Engine / Framework:** Phaser 3 oder PixiJS + TypeScript
- **Build:** Vite
- **Deployment:** GitHub Pages / statisches Hosting

### 11.3 MVP-Umfang (Version 0.1)

- [ ] 1 spielbares Level
- [ ] Bewegung (Gehen, Rennen, Kriechen)
- [ ] 2 Wachtypen (Patrouille, Wachposten)
- [ ] Sichtkegel & Schatten
- [ ] Lautlose Eliminierung
- [ ] Alarm-System (Grün / Gelb / Rot)
- [ ] Sieg / Niederlage-Bildschirm
- [ ] Ghost-Rating (S / A / B / C)

### 11.4 Nicht im MVP

- Kampagne (12 Missionen)
- Freischaltbare Ausrüstung
- Gamepad-Support
- Mehrsprachigkeit

---

## 12. Roadmap

| Phase | Inhalt | Ziel |
|-------|--------|------|
| **Phase 0** | Konzept & Prototyp | Dieses Dokument, 1 Greybox-Level |
| **Phase 1** | MVP | Spielbarer Kern-Loop, 1 Level poliert |
| **Phase 2** | Alpha | 5 Level, alle Wachtypen, Ausrüstung |
| **Phase 3** | Beta | 12 Level, Ghost-Rating, Audio, UI |
| **Phase 4** | Release | Balancing, Bugfixes, Deployment |

---

## 13. Offene Fragen

1. Soll das Spiel **rundenbasiert** (Zug für Zug) oder **in Echtzeit** sein?
2. Gibt es eine **Geschichte / Cutscenes** oder nur Mission-Briefings?
3. Soll ein **Level-Editor** für die Community geplant werden?
4. **Permadeath** pro Mission oder unbegrenzte Wiederholungen?

---

## 14. Referenzen & Inspiration

- *Mark of the Ninja* — Schatten & Sichtkegel
- *Stealth Inc.* — Puzzle-Stealth aus Vogelperspektive
- *Tenchu* — Ninja-Fantasie & Setting
- *Hotline Miami* — Schnelle Missionen, klares Feedback
- *Desperados III* — Taktische Planung, Ghost-Rating

---

*Dokument erstellt als Grundlage für die Entwicklung von Ninja Assassin.*
