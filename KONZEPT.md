# Ninja Assassin — Konzeptdokument

**Version:** 2.2  
**Datum:** 28. August 2026  
**Sprache:** Deutsch  
**Projekt:** [ninja-assassin](https://github.com/Rnonog/ninja-assassin)

---

## 1. Elevator Pitch

*Ninja Assassin* ist ein düsteres 2D-Action-Spiel aus der Seitenansicht. Ein einsamer Shinobi kämpft sich von seiner Heimat in Japan bis in die Neon-Schatten von New York — Level für Level, Gegner für Gegner, Boss für Boss. Katana und Wurfsterne gegen ein Arsenal aus Messern, Äxten, Bögen und Schusswaffen.

> **Kurzform:** Ein Pfad. Zwei Welten. Kein Entkommen — nur Vorwärts.

---

## 2. Spielvision

### 2.1 Kernfantasie

Der Spieler erlebt die brutale Odyssee eines Ninja, der alles verloren hat und nur noch den Weg nach vorn kennt. Jedes Level ist ein weiteres Stück dieser Reise — von nebligen Wäldern über Dächer im Mondlicht bis in die kalten Straßen einer fremden Metropole. Die Stimmung ist düster, bedrohlich und unerbittlich.

### 2.2 Zielgruppe

- Fans von 2D-Action-Plattformern (*Shinobi*, *Ninja Gaiden*, *Katana ZERO*)
- Spieler, die herausforderndes Kampfdesign und atmosphärische Welten schätzen
- Altersempfehlung: **16+** (düstere Thematik, stilisierte Gewalt)

### 2.3 Alleinstellungsmerkmale (USP)

| Merkmal | Beschreibung |
|---------|--------------|
| **Reise von Ost nach West** | Einzigartiger visueller und atmosphärischer Wandel von feudalem Japan bis zu modernem New York |
| **Düstere Ästhetik** | Gedämpfte Farben, harte Schatten, Regen, Nebel — kein helles Abenteuer |
| **Boss nach jedem Level** | Jeder Abschnitt endet mit einem stärkeren Endboss — klarer Schwierigkeitsanstieg |
| **Vielfältiges Waffen-Arsenal** | Gegner nutzen je nach Region und Typ unterschiedliche Waffen — von Messer und Axt bis Pistole und Gewehr; der Ninja bleibt mit Katana und Wurfsternen unterlegen, muss aber clever kämpfen |
| **Waffen lesbar im Kampf** | Jede Gegnerwaffe hat ein erkennbares Angriffsmuster — der Spieler lernt, wie er gegen jede Bedrohung reagiert |

---

## 3. Handlung

### 3.1 Prämisse

Der Ninja stammt aus einem abgelegenen Dorf in den Bergen Japans. Eine feindliche Organisation — der **Schwarze Klan** — vernichtet seine Heimat und tötet seine Familie. Der einzige Überlebende schwört Rache und folgt den Spuren des Klans quer durch die Welt, bis er deren Anführer in den Hochhäusern New Yorks stellt.

### 3.2 Dramaturgische Bögen

| Akt | Setting | Stimmung |
|-----|---------|----------|
| **Akt I — Japan** | Wälder, Tempel, Dörfer, Dächer | Melancholisch, nebelverhangen, traditionell |
| **Akt II — Übergang** | Hafen, Schiff, Küste | Unruhe, Abschied, Aufbruch |
| **Akt III — New York** | Straßen, Dächer, U-Bahn, Wolkenkratzer | Kalt, neonbeleuchtet, urban, bedrohlich |

### 3.3 Finale

Im letzten Level erklimmt der Ninja den Gipfel eines Wolkenkratzers und stellt dem Anführer des Schwarzen Klans — dem Mann, der alles begann — ein letztes Mal.

### 3.4 Cutscenes

Die Story wird durch **Cutscenes** erzählt — vor, während und nach Leveln.

| Zeitpunkt | Inhalt | Beispiel |
|-----------|--------|----------|
| **Spielstart** | Einführung in Handlung und Motivation | Zerstörung des Dorfes, Schwur des Ninja |
| **Vor Level** | Kurzes Briefing — wo, warum, wer wartet | „Der Klan hat den Tempel besetzt …" |
| **Nach Level** | Reaktion auf Boss-Sieg, Übergang zur nächsten Region | Ninja verlässt Japan, betritt das Schiff |
| **Nach Akt** | Größere Zwischensequenz zwischen Japan und New York | Ankunft in New York bei Nacht |
| **Finale** | Abschluss-Cutscene nach Sieg über den Endboss | Rache vollendet — offenes Ende |

**Stil der Cutscenes:**
- In-Engine-Animationen mit düsterer Silhouetten-Ästhetik (kein Vollbild-Video)
- Minimale Dialoge — Bilder und kurze Textzeilen tragen die Emotion
- Überspringbar mit einer Taste (Esc / B)

---

## 4. Spielprinzip & Ziel

### 4.1 Hauptziel

Jedes Level von links nach rechts durchqueren, alle Gegner besiegen, den **Endboss** eliminieren und zum Ausgang gelangen.

### 4.2 Siegbedingungen

- Endboss besiegt
- Ausgang / Level-Ende erreicht

### 4.3 Niederlagebedingungen

- Lebenspunkte des Ninja auf 0 → Respawn am **letzten Checkpoint**
- Absturz in tiefe Fallen → Respawn am letzten Checkpoint (kein sofortiger Tod)

### 4.4 Checkpoints

- Jedes Level enthält **2–4 Checkpoints** an strategischen Punkten (nach schwierigen Abschnitten, vor Boss-Arenen)
- Aktivierung automatisch beim Passieren (Laternen / Schreine als visuelle Marker)
- Beim Tod: Respawn am Checkpoint mit **vollem Leben**, Wurfsterne auf Stand bei Aktivierung
- Beim Verlassen eines Levels: Checkpoints werden zurückgesetzt

---

## 5. Spielmechaniken

### 5.1 Bewegung

| Aktion | Beschreibung |
|--------|--------------|
| **Laufen** | Standardbewegung nach links/rechts |
| **Springen** | Einzel- und Doppelsprung |
| **Wandsprung** | An Wänden abstoßen (ab Level 3) |
| **Klettern** | Leitern, Seile, Dachkanten |
| **Ausweichen** | Kurzer Roll-Sprung mit kurzer Unverwundbarkeit |

### 5.2 Waffen des Ninja

#### Katana (Nahkampf)

- **Leichter Hieb:** Schnell, geringer Schaden
- **Schwerer Hieb:** Langsamer, hoher Schaden, bricht gegnerische Abwehr
- **Combo-Kette:** Bis zu 3 aufeinanderfolgende Hiebe bei präzisem Timing
- **Luft-Angriff:** Abwärts-Hieb beim Springen

#### Wurfsterne (Fernkampf)

- Begrenzte Anzahl pro Level (Nachschub durch Pickups)
- Schnelle Projektile in Wurfrichtung
- Geringerer Schaden als Katana, aber sicherer Abstand
- Können Wurfangriffe der Gegner unterbrechen

#### Rauchbombe (Situativ, begrenzt)

- **1–2 pro Level** als Pickup — kein Upgrade, nur taktische Hilfe
- Erzeugt eine Rauchwolke, die **Sichtlinien blockiert** (Gegner verlieren kurz den Anblick)
- Nützlich gegen Schützen und in Boss-Phasen zum Repositionieren
- Passt zur düsteren Ninja-Ästhetik — kein greller Effekt, nur aufsteigender schwarzer Nebel

#### Kettenhaken (Level-Mechanik)

- Keine Kampfwaffe — nur in markierten Abschnitten einsetzbar (Dächer, Hafen, NY)
- Zieht den Ninja zu Hakenspitzen oder senkrechten Wänden
- Erweitert Level-Navigation ohne den festen Charakter zu verändern

### 5.3 Waffen-Arsenal — Übersicht

#### Waffen des Ninja (fest)

| Waffe | Typ | Rolle |
|-------|-----|-------|
| **Katana** | Nahkampf | Hauptwaffe — Combos, Block-Break |
| **Wurfsterne** | Fernkampf | Distanz, Unterbrechung, begrenzte Munition |
| **Rauchbombe** | Taktik | Ablenkung, Deckung, Flucht |

#### Gegnerwaffen nach Region

**Japan — traditionell & Klan-Waffen**

| Waffe | Gegnertyp | Kampfverhalten |
|-------|-----------|----------------|
| **Messer** | Klan-Schläger | Schnelle Stiche, kurze Reichweite |
| **Axt** | Holzfäller / Klan-Vollstrecker | Langsamer Wind-up, hoher Schaden, kann Boden rütteln |
| **Wurfaxt** | Wald-Jäger | Geworfen, bleibt kurz im Boden stecken — Ausweichen nötig |
| **Katana** | Katana-Krieger, Schatten-Ninja | Block, Combos |
| **Wurfsterne** | Wurfkämpfer | Fernkampf aus sicherer Distanz |
| **Bogen** | Bogenschütze | Pfeile von erhöhter Position |
| **Naginata** | Tempel-Wächter | Längere Reichweite als Katana — Haltungskampf |
| **Nunchaku** | Straßenkämpfer (Japan) | Schnelle Schläge, schwer ausweichbar |
| **Kette & Eisenkugel** | Hafen-Meister (Boss) | Mittlere Reichweite, umschlingt bei Treffer kurz |

**Übergang — Schiff & Hafen**

| Waffe | Gegnertyp | Kampfverhalten |
|-------|-----------|----------------|
| **Säbel (Cutlass)** | Schiffskapitän, Piraten | Breite Schwünge auf engem Deck |
| **Harpune** | Deck-Arbeiter | Langsame Projektile, hoher Schaden |
| **Flintlock-Pistole** | Schiffsoffizier | Ein Schuss, langes Nachladen — telegraphiert |

**New York — modern & urban**

| Waffe | Gegnertyp | Kampfverhalten |
|-------|-----------|----------------|
| **Pistole** | Gangmitglied, Zoll-Wächter | Mittlere Reichweite, schnelle Schüsse |
| **Revolver** | Chinatown-Boss | 6 Schuss-Salve, dann Pause |
| **Sturmgewehr** | Klan-Söldner | Dauerfeuer — Deckung oder Ausweichen zwingend |
| **Schrotflinte** | U-Bahn-Jäger | Kurze Reichweite, extrem hoher Schaden |
| **Sniper-Gewehr** | Dach-Sniper | Sehr lange Reichweite, roter Laser als Warnung |
| **Baseballschläger** | Straßen-Krieger | Nahkampf, kann Ninja zurückschleudern |
| **Dual Karambit** | Chinatown-Assassine | Doppel-Klingen, schnelle Combo-Stiche |
| **Elektroschocker** | NY-Security | Kurzer Stun bei Treffer (~1 Sekunde) |
| **Molotow-Cocktail** | Straßenschläger | Flächenschaden am Boden, brennt 3 Sekunden |
| **Gasgranate** | U-Bahn-Spezialist | Reduziert Sichtfeld des Spielers kurzzeitig |

#### Eigene Waffen-Ideen (designspezifisch)

| Waffe | Konzept | Gameplay-Idee |
|-------|---------|---------------|
| **Shuriken-Falle** | Gegner legt Bodenfallen | Leuchtet schwach — Ninja muss springen oder ausweichen |
| **Fackel-Werfer** | Tempel-Wächter (Phase 2) | Erhellt Arena, verbrennt Rauchbombe sofort |
| **Kettensäge** | Wall-Street-Minion | Laut, langsam, hoher Schaden — akustische Warnung |
| **Armbrust (schwer)** | Dach-Elite | Durchdringender Bolzen — blockt nicht, nur Ausweichen |
| **Dual-Pistolen** | Klan-Elite (Boss Phase 1) | Akimbo-Schüsse in wechselnden Mustern |
| **Ninjato (gebrochene Klinge)** | Anführer des Schwarzen Klans | Finaler Boss — schnellere Combos als Spieler-Katana |

### 5.4 Kampfsystem

```
Nahkampf:  Leichter Hieb → Leichter Hieb → Schwerer Hieb (Combo)
Fernkampf: Wurfstern (begrenzte Munition)
Defensive: Ausweichen (i-Frames), Blocken (reduziert Schaden, kurze Erholung — schwach gegen Schrotflinte/Gewehr)
```

- **Treffer-Feedback:** Bildschirm-Shake, kurzer Freeze-Frame bei kritischen Treffern
- **Gegner-Reaktion:** Gegner taumeln bei starken Hieben, Elite-Gegner können blocken

### 5.5 Leben & Schaden

- **Lebenspunkte:** Fester Wert von **100 HP** — keine Upgrades, keine permanente Steigerung
- **Keine Regeneration:** HP regenerieren sich nicht automatisch
- **Heilung:** Seltener Pickup im Level (Medizin-Rolle / Erste-Hilfe-Kit, +30 HP)
- **Schaden:** Abhängig von Waffe und Gegnertyp (Messer ~10 HP, Axt ~20 HP, Schusswaffen ~15–30 HP, Boss ~25 HP pro Treffer)
- **Tod:** Respawn am letzten Checkpoint mit vollem Leben

### 5.6 Fester Charakter — keine Upgrades

Der Ninja ist von Anfang bis Ende **statisch** — keine sammelbaren Verbesserungen.

| Fest definiert | Nicht im Spiel |
|----------------|----------------|
| 100 HP | HP-Upgrades |
| Katana (leicht + schwer) | Waffen-Upgrades |
| Wurfsterne (begrenzt pro Level) | Permanente Munitions-Erhöhung |
| Rauchbombe (1–2 Pickups pro Level) | Zusätzliche Waffen freischalten |
| Feste Combo-Kette | Skill-Bäume |
| Ausweichen mit i-Frames | Cooldown-Reduktionen |

Schwierigkeitssteigerung entsteht ausschließlich durch **härtere Level, stärkere Gegner und anspruchsvollere Bosse** — nicht durch stärker werdenden Spieler.

---

## 6. Level-Design

### 6.1 Level-Typen

| Typ | Setting | Besonderheiten |
|-----|---------|----------------|
| **Wald** | Bambus, Kiefern, Felsen, Wasserfall | Unebener Boden, versteckte Gegner hinter Bäumen |
| **Dächer** | Japanische Dachlandschaft / NY-Skyline | Abgründe, Sprung-Puzzles, Wind als Hindernis |
| **Stadt** | Gassen, Straßen, Neon, U-Bahn-Schächte | Engere Gänge, mehr Fernkämpfer, Sicherheitssysteme |

### 6.2 Struktur eines Levels

```
[Einstieg] → [Kampfzone 1] → [Plattform-Abschnitt] → [Kampfzone 2] → [Endboss-Arena] → [Ausgang]
```

- Jedes Level dauert ca. **5–10 Minuten**
- Vor dem Boss: kurzer Versorgungsabschnitt (Heilung, Wurfsterne)
- Boss-Arena ist abgetrennt — kein Zurückfliehen

### 6.3 Level-Übersicht (Entwurf)

| Nr. | Name | Setting | Endboss |
|-----|------|---------|---------|
| 1 | *Nebliger Wald* | Japan — Wald | Klan-Schläger |
| 2 | *Tempel der Asche* | Japan — Tempel | Tempel-Wächter |
| 3 | *Dächer von Kyoto* | Japan — Dächer | Schatten-Ninja |
| 4 | *Verlassenes Dorf* | Japan — Dorf | Klan-Kommandant |
| 5 | *Hafen im Sturm* | Japan — Küste | Hafen-Meister |
| 6 | *Über dem Meer* | Schiff / Transit | Schiffskapitän |
| 7 | *Ankunft* | New York — Hafen | Zoll-Wächter |
| 8 | *Chinatown* | New York — Stadt | Straßen-Krieger |
| 9 | *U-Bahn-Schatten* | New York — Untergrund | U-Bahn-Jäger |
| 10 | *Neon-Dächer* | New York — Dächer | Dach-Sniper |
| 11 | *Wall Street* | New York — Finanzdistrikt | Klan-Elite |
| 12 | *Der Gipfel* | New York — Wolkenkratzer | **Anführer des Schwarzen Klans** |

---

## 7. Gegner & Endbosse

### 7.1 Standard-Gegnertypen

| Typ | Waffe(n) | Verhalten | Vorkommen |
|-----|----------|-----------|-----------|
| **Klan-Schläger** | Messer, Faust | Rennt auf Spieler zu, schnelle Stiche | Japan, frühe Level |
| **Axt-Kämpfer** | Axt | Langsamer, schwerer Hieb, hoher Schaden | Japan — Wald, Dorf |
| **Wurfkämpfer** | Wurfsterne, Wurfaxt | Hält Abstand, wirft aus der Ferne | Ab Level 2 |
| **Katana-Krieger** | Katana | Blockt, führt Combos aus | Ab Level 3 |
| **Bogenschütze** | Bogen | Plattform-Position, schießt von oben | Wälder, Dächer |
| **Naginata-Wächter** | Naginata | Längere Reichweite, hält Position | Tempel, Level 2 |
| **Schatten-Ninja** | Katana + Wurfsterne | Teleportiert kurz, kombiniert Nah- und Fernkampf | Ab Level 5 |
| **Deck-Matrose** | Harpune, Cutlass | Enger Nahkampf auf Plattformen | Schiff, Level 6 |
| **Gangmitglied** | Pistole, Baseballschläger | Schießt oder schlägt im Wechsel | NY — ab Level 7 |
| **Klan-Söldner** | Sturmgewehr | Dauerfeuer, sucht Deckung | NY — Straßen, ab Level 8 |
| **Chinatown-Assassine** | Dual Karambit | Sehr schnelle Combos, niedrige HP | NY — Chinatown |
| **Sniper** | Sniper-Gewehr | Sehr hohe Plattform, roter Laser vor Schuss | NY-Dächer |
| **U-Bahn-Jäger** | Schrotflinte, Gasgranate | Lauert in Dunkelheit, Flächenangriffe | NY — Untergrund |
| **NY-Security** | Elektroschocker, Pistole | Stun + Nahkampf | NY — Wall Street |
| **Elite-Wache** | Katana (schwer) oder Sturmgewehr | Hohe HP, langsam aber verheerend | Späte Level |

### 7.2 Endbosse

Jeder Endboss ist **deutlich stärker** als der vorherige — mehr Leben, mehr Angriffsmuster, eigene Arena.

| Level | Boss | Waffe(n) | Besonderheit |
|-------|------|----------|--------------|
| 1 | **Klan-Schläger-Hauptmann** | Axt | Erhöhte HP, Stampf-Angriff |
| 2 | **Tempel-Wächter** | Naginata + Fackel | Drei-Phasen-Kampf, Fackel neutralisiert Rauch |
| 3 | **Schatten-Zwillinge** | Katana + Wurfsterne | Zwei Bosse gleichzeitig |
| 4 | **Klan-Kommandant** | Katana + Pistole | Combos im Nahkampf, Schüsse auf Distanz |
| 5 | **Hafen-Meister** | Kette & Eisenkugel | Mittlere Reichweite, umschlingt bei Treffer |
| 6 | **Schiffskapitän** | Cutlass + Flintlock | Kampf auf schwankendem Deck |
| 7 | **Zoll-Wächter** | Schild + Pistole | Blockt frontal, schießt bei Lücken |
| 8 | **Straßen-Krieger** | Baseballschläger + Dual Karambit | Phase 1 Schläger, Phase 2 Klingen |
| 9 | **U-Bahn-Jäger** | Schrotflinte + Gasgranate | Angriffe aus der Dunkelheit |
| 10 | **Dach-Sniper** | Sniper-Gewehr + Armbrust | Fernkampf + Fallen auf dem Dach |
| 11 | **Klan-Elite** | Dual-Pistolen + Sturmgewehr | Phase 1 Akimbo, Phase 2 Dauerfeuer |
| 12 | **Anführer des Schwarzen Klans** | Ninjato + alle Waffen | Finaler Boss — 4 Phasen, wechselndes Arsenal |

### 7.3 Boss-Design-Prinzipien

1. Jeder Boss lehrt eine **neue Kampftechnik**, die der Spieler beherrschen muss
2. Klare **Angriffsmuster** — lernbar, aber unerbittlich
3. **Telegraphing:** Boss-Angriffe sind visuell ankündigt (Aufwinden, Leuchten)
4. **Schwachpunkt-Phasen:** Nach schweren Angriffen kurzes Zeitfenster für Konter

---

## 8. Steuerung

### 8.1 Tastatur (PC)

| Taste | Aktion |
|-------|--------|
| A / D oder ← / → | Bewegung links / rechts |
| Leertaste | Springen |
| J | Leichter Katana-Hieb |
| K | Schwerer Katana-Hieb |
| L | Wurfstern werfen |
| Shift | Ausweichen |
| Esc | Pause |

### 8.2 Gamepad

| Taste | Aktion |
|-------|--------|
| Linker Stick | Bewegung |
| A / X | Springen |
| X / □ | Leichter Hieb |
| Y / △ | Schwerer Hieb |
| B / ○ | Wurfstern |
| RB / R1 | Ausweichen |

---

## 9. Visueller Stil

### 9.1 Art Direction — Düster

- **Perspektive:** 2D-Seitenansicht (Side-Scroller)
- **Stimmung:** Düster, bedrohlich, melancholisch
- **Farbpalette Japan:** Gedämpftes Grün, Grau, tiefes Rot, Mondlicht-Blau
- **Farbpalette New York:** Neon-Pink, kaltes Blau, Asphalt-Grau, gelbes Straßenlicht
- **Beleuchtung:** Starke Kontraste — helle Silhouetten vor dunklem Hintergrund
- **Wetter:** Regen, Nebel, Schnee (Japan) / Regen, Nacht (New York)

### 9.2 Charakter-Design

- **Ninja:** Schwarze Silhouette mit rotem Schal — minimal, ikonisch
- **Gegner:** Variierende Silhouetten je nach Typ, erkennbar an Waffen-Haltung
- **Endbosse:** Größer, detaillierter, eigene Farbakzente (z. B. rote Rüstung)

### 9.3 UI / HUD

- Schlichter Lebensbalken oben links
- Wurfstern-Zähler oben rechts
- Boss-Lebensbalken unten Mitte (nur im Bosskampf)
- Kein überladenes HUD — Fokus auf die Spielwelt

---

## 10. Audio

| Kategorie | Beschreibung |
|-----------|--------------|
| **Musik Japan** | Langsame Shamisen, tiefe Taiko, düstere Flöten — wenig Melodie, viel Atmosphäre |
| **Musik New York** | Synthwave-Ambient, dumpfe Bässe, entfremdet |
| **Boss-Musik** | Intensiver, schnelleres Tempo, einzigartig pro Boss |
| **SFX Kampf** | Metallisches Klirren (Katana), Wispern (Wurfsterne), Knall (Schusswaffen), dumpfe Treffer (Axtschlag), Zischen (Gasgranate) |
| **Umgebung** | Regen, Wind, entfernte Sirenen (NY), Kickeulen (Japan) |

---

## 11. Technischer Scope (MVP)

### 11.1 Plattform

- **Web** (Browser, Desktop & Mobile) — primäres Ziel
- Optional später: Steam / Desktop-Export

### 11.2 Tech-Stack (Vorschlag)

- **Engine / Framework:** Phaser 3 + TypeScript
- **Build:** Vite
- **Deployment:** GitHub Pages / statisches Hosting

### 11.3 MVP-Umfang (Version 0.1)

- [ ] 1 spielbares Level (Wald, Japan)
- [ ] Ninja-Bewegung (Laufen, Springen, Ausweichen)
- [ ] Katana (leichter + schwerer Hieb)
- [ ] Wurfsterne (Fernkampf, begrenzte Munition)
- [ ] 2 Gegnertypen (Schläger, Wurfkämpfer)
- [ ] 1 Endboss (Klan-Schläger-Hauptmann)
- [ ] Lebens- & Schadenssystem
- [ ] Sieg / Niederlage-Bildschirm
- [ ] Düstere Grund-Atmosphäre (Farben, Hintergrund)
- [ ] 1 Checkpoint pro Level
- [ ] Intro-Cutscene (Spielstart)

### 11.4 Nicht im MVP

- Vollständige Kampagne (12 Level)
- Alle Gegnertypen und Bosse
- New-York-Setting
- Gamepad-Support
- Cutscenes zwischen allen Leveln (nur Intro im MVP)

---

## 12. Roadmap

| Phase | Inhalt | Ziel |
|-------|--------|------|
| **Phase 0** | Konzept & Prototyp | Dieses Dokument, 1 Greybox-Level |
| **Phase 1** | MVP | 1 Level (Wald), Kampf, 1 Boss — spielbar im Browser |
| **Phase 2** | Alpha | 6 Level (Japan-Akt), alle JP-Gegnertypen, 6 Bosse |
| **Phase 3** | Beta | 12 Level (Japan + NY), alle Bosse, Cutscenes, Audio, UI |
| **Phase 4** | Release | Balancing, Cutscenes, Bugfixes, Deployment |

---

## 13. Design-Entscheidungen

| Frage | Entscheidung | Auswirkung |
|-------|--------------|------------|
| Lebenssystem | **Lebenspunkte** (100 HP) | Mehrere Treffer erlaubt, Heilungs-Pickups sinnvoll |
| Tod & Wiederholung | **Checkpoints** | Respawn am letzten Checkpoint mit vollem Leben |
| Storytelling | **Cutscenes** | In-Engine-Sequenzen vor/nach Leveln und zwischen Akten |
| Charakter-Progression | **Fester Charakter** | Keine Upgrades — Schwierigkeit nur über Level & Gegner |

---

## 14. Referenzen & Inspiration

- *Shinobi* (Arcade) — 2D-Ninja-Action, Side-Scroller
- *Ninja Gaiden* — Herausfordernder Schwertkampf
- *Katana ZERO* — Düstere Ästhetik, präzises Kampfdesign
- *Hollow Knight* — Atmosphäre, Boss-Design
- *Ghost of Tsushima* — Japan-Setting, Samurai/Ninja-Fantasie
- *Max Payne* — Düstere Großstadt, Rache-Erzählung

---

*Dokument erstellt als Grundlage für die Entwicklung von Ninja Assassin.*
