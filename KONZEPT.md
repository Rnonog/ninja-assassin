# Ninja Assassin — Konzeptdokument

**Version:** 2.6  
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
- **Counter:** Fackel-Werfer (Tempel-Wächter Phase 2) **verbrennt die Rauchwolke sofort** — in dieser Phase ist die Rauchbombe wirkungslos; Spieler muss Nahkampf oder Ausweichen nutzen

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
| **Shuriken-Falle** | Fallenleger | Bodenfalle — schwach leuchtend, Ausweichen oder Sprung nötig |
| **Fackel-Werfer** | Tempel-Wächter (Phase 2) | Erhellt Arena, verbrennt Rauchbombe sofort |

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
| **Kettensäge** | Kettensäge-Minion | Laut, langsam, hoher Schaden — akustische Warnung vor Angriff |
| **Armbrust (schwer)** | Dach-Elite | Durchdringender Bolzen — Block unwirksam, nur Ausweichen |
| **Dual-Pistolen** | Klan-Elite (Phase 1) | Akimbo-Schüsse in wechselnden Mustern |
| **Ninjato (gebrochene Klinge)** | Anführer des Schwarzen Klans | Schnellere Combos als Spieler-Katana — Finalboss-Waffe |

### 5.4 Kampfsystem

```
Nahkampf:  Leichter Hieb → Leichter Hieb → Schwerer Hieb (Combo)
Fernkampf: Wurfstern (begrenzte Munition)
Defensive: Ausweichen (i-Frames), Blocken (reduziert Schaden, kurze Erholung)
           Block unwirksam gegen: Armbrust (schwer), Sturmgewehr-Dauerfeuer, Schrotflinte
Taktik:    Rauchbombe (Sicht blockieren) — von Fackel-Werfer sofort neutralisiert
```

- **Treffer-Feedback:** Bildschirm-Shake, kurzer Freeze-Frame bei kritischen Treffern
- **Gegner-Reaktion:** Gegner taumeln bei starken Hieben, Elite-Gegner können blocken
- **Durchdringende Angriffe:** Armbrust (schwer) und schwere Schusswaffen ignorieren Block vollständig — Spieler muss ausweichen oder hinter Deckung gehen
- **Bodenfallen:** Shuriken-Fallen bleiben nach Auslösung kurz sichtbar — erneutes Betreten verursacht erneut Schaden
- **Fackel vs. Rauchbombe:** In Tempel-Wächter Phase 2 erhellt die Fackel die gesamte Arena und verbrennt jede Rauchwolke bei Kontakt — taktischer Gegen-Counter zum Ninja-Deckungswerkzeug

### 5.5 Leben & Schaden

- **Lebenspunkte:** Fester Wert von **100 HP** — keine Upgrades, keine permanente Steigerung
- **Keine Regeneration:** HP regenerieren sich nicht automatisch
- **Heilung:** Seltener Pickup im Level (Medizin-Rolle / Erste-Hilfe-Kit, +30 HP)
- **Schaden:** Abhängig von Waffe und Gegnertyp (Messer ~10 HP, Axt ~20 HP, Shuriken-Falle ~15 HP, Schusswaffen ~15–30 HP, Kettensäge ~35 HP, Armbrust ~25 HP — nicht blockbar, Fackel ~20 HP Flächenschaden, Boss ~25 HP pro Treffer)
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
| **Fallenleger** | Shuriken-Falle | Legt Bodenfallen, hält Abstand; schwache Leuchte als Warnung | Japan — Wald, Tempel (ab Level 1–2) |
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
| **Dach-Elite** | Armbrust (schwer) | Hohe HP, durchdringende Bolzen — Block unwirksam | NY — Neon-Dächer (Level 10) |
| **U-Bahn-Jäger** | Schrotflinte, Gasgranate | Lauert in Dunkelheit, Flächenangriffe | NY — Untergrund |
| **Kettensäge-Minion** | Kettensäge | Langsam, laut (Motor-Geräusch), verheerender Nahkampf | NY — Wall Street (Level 11) |
| **NY-Security** | Elektroschocker, Pistole | Stun + Nahkampf | NY — Wall Street |
| **Elite-Wache** | Katana (schwer) oder Sturmgewehr | Hohe HP, langsam aber verheerend | Späte Level |

### 7.2 Endbosse

Jeder Endboss ist **deutlich stärker** als der vorherige — mehr Leben, mehr Angriffsmuster, eigene Arena.

| Level | Boss | Waffe(n) | Besonderheit |
|-------|------|----------|--------------|
| 1 | **Klan-Schläger-Hauptmann** | Axt | Erhöhte HP, Stampf-Angriff |
| 2 | **Tempel-Wächter** | Naginata + **Fackel-Werfer** | **Phase 1:** Naginata-Haltungskampf. **Phase 2:** Wechsel zur Fackel — erhellt die Arena (reduziert Schatten-Deckung), **verbrennt Rauchbombe sofort** bei Kontakt. **Phase 3:** Kombination beider Waffen |
| 3 | **Schatten-Zwillinge** | Katana + Wurfsterne | Zwei Bosse gleichzeitig |
| 4 | **Klan-Kommandant** | Katana + Pistole | Combos im Nahkampf, Schüsse auf Distanz |
| 5 | **Hafen-Meister** | Kette & Eisenkugel | Mittlere Reichweite, umschlingt bei Treffer |
| 6 | **Schiffskapitän** | Cutlass + Flintlock | Kampf auf schwankendem Deck |
| 7 | **Zoll-Wächter** | Schild + Pistole | Blockt frontal, schießt bei Lücken |
| 8 | **Straßen-Krieger** | Baseballschläger + Dual Karambit | Phase 1 Schläger, Phase 2 Klingen |
| 9 | **U-Bahn-Jäger** | Schrotflinte + Gasgranate | Angriffe aus der Dunkelheit |
| 10 | **Dach-Sniper** | Sniper-Gewehr + **Armbrust (schwer)** | Fernkampf von Plattformen; **Armbrust-Bolzen durchdringen Block** — nur Ausweichen oder Deckung. Shuriken-Fallen auf dem Dach als zusätzliche Bedrohung |
| 11 | **Klan-Elite** | **Dual-Pistolen** + Sturmgewehr | **Phase 1:** Akimbo-Schüsse in wechselnden Mustern (links/rechts/hoch). **Phase 2:** Sturmgewehr-Dauerfeuer — Deckung zwingend |
| 12 | **Anführer des Schwarzen Klans** | **Ninjato (gebrochene Klinge)** + Arsenal | **4 Phasen.** **Phase 1:** Ninjato — **schnellere Combos als Spieler-Katana** (4-Hieb-Kette), erfordert präzises Ausweichen. Phasen 2–4: wechselndes Arsenal (Pistole, Sturmgewehr, Wurfsterne) |

### 7.3 Boss-Design-Prinzipien

1. Jeder Boss lehrt eine **neue Kampftechnik**, die der Spieler beherrschen muss
2. Klare **Angriffsmuster** — lernbar, aber unerbittlich
3. **Telegraphing:** Boss-Angriffe sind visuell ankündigt (Aufwinden, Leuchten)
4. **Schwachpunkt-Phasen:** Nach schweren Angriffen kurzes Zeitfenster für Konter
5. **Waffen-Counter:** Bosse können Ninja-Werkzeuge neutralisieren (Fackel vs. Rauchbombe) — erzwingt Anpassung statt Einheits-Taktik
6. **Unblockbare Bedrohungen:** Armbrust und schwere Schusswaffen lehren, dass Block nicht immer die Antwort ist

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
| R | Rauchbombe (wenn vorhanden) |
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
| **SFX Kampf** | Metallisches Klirren (Katana), Wispern (Wurfsterne), Knall (Schusswaffen), dumpfe Treffer (Axtschlag), Zischen (Gasgranate), Kreischen (Kettensäge), leises Klicken (Shuriken-Falle), Feuer-Zischen (Fackel-Werfer), schwerer Bolzen-Aufprall (Armbrust), doppelter Pistolen-Knall (Dual-Pistolen), scharfes Klirren (Ninjato) |
| **Umgebung** | Regen, Wind, entfernte Sirenen (NY), Kickeulen (Japan) |

---

## 11. Technischer Scope (MVP)

### 11.1 Plattform

- **Web** (Browser, Desktop & Mobile) — primäres Ziel
- Optional später: Steam / Desktop-Export

### 11.2 Tech-Stack

- **Engine:** Godot 4 (GDScript)
- **Grafik:** 2D Pixel-Art / Tilemaps, Parallax-Hintergründe
- **Zielplattformen:** Desktop (Windows, Linux, macOS), optional Web-Export
- **Deployment:** GitHub Releases / itch.io

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
- Doppelsprung, Wandsprung, Klettern, Rauchbombe, Kettenhaken, Block
- Combokette als Pflicht (Stretch in Stufe 2)
- Fallenleger / Shuriken-Falle

---

## 12. Roadmap

| Phase | Inhalt | Ziel |
|-------|--------|------|
| **Phase 0** | Konzept & Prototyp | Dieses Dokument — **erledigt** |
| **Phase 1** | MVP | 1 Level (Wald), Kampf, 1 Boss — spielbar im Browser |
| **Phase 2** | Alpha | 6 Level (Japan-Akt), alle JP-Gegnertypen, 6 Bosse |
| **Phase 3** | Beta | 12 Level (Japan + NY), alle Bosse, Cutscenes, Audio, UI |
| **Phase 4** | Release | Balancing, Cutscenes, Bugfixes, Deployment |

### 12.1 MVP-Implementierung (Phase 1 in sechs Stufen)

**Regel:** Jede Stufe endet spielbar. Feel vor Content, Loop vor Politur. Platzhalter-Art bis Stufe 6. Jede Stufe ist eine eigene Plan-Aufgabe (INDEX + Slices → Freigabe → Implementer → Review → Playtest).

**Fortschritt:** Nach jeder Stufe Status in dieser Tabelle aktualisieren (`offen` / `in Umsetzung` / `erledigt`). `erledigt` erst nach Playtest und Push.

| Stufe | Name | Status | Spieler kann danach | Fertig wenn |
|-------|------|--------|---------------------|-------------|
| **1** | Steuerung & Greybox | **erledigt** | Laufen, springen, ausweichen | Steuerung fühlt sich unmittelbar an; Szene startet ohne Fehler |
| **2** | Nahkampf & Leben | **erledigt** | Mit Katana treffen und sterben | Leicht/schwer unterscheidbar; Tod bei 0 HP |
| **3** | Fernkampf & Gegner | offen | Wurfsterne + Schläger + Wurfkämpfer | Munition begrenzt; beide Muster lesbar |
| **4** | Level *Nebliger Wald* | offen | Von links nach rechts bis zur Arena | 1 Checkpoint, Respawn, 5–10 Min. |
| **5** | Boss, Sieg, Intro | offen | Hauptmann besiegen, Intro skippen | Spielschleife geschlossen |
| **6** | Atmosphäre, HUD, Export | offen | Düsteres Level im Browser | Alle Punkte aus §11.3 abgehakt |

**Stufe 1 — Steuerung & Greybox**
- Godot 4 Projekt, Szenenbaum (Main / Player / Level), Input Map laut §8.1
- CharacterBody2D: Gravitation, Laufen, Springen, Ausweichen mit i-Frames; Kamera folgt
- Greybox-Boden und Plattformen — keine Pixel-Art

**Stufe 2 — Nahkampf & Leben**
- Leichter und schwerer Katana-Hieb mit Hitboxes; Dummy mit Hurtbox
- 100 HP, Schaden, Tod; minimales Treffer-Feedback (Freeze-Frame oder Shake)
- Combokette ist Stretch, kein Blocker

**Stufe 3 — Fernkampf & Gegner**
- Wurfsterne (Richtung, begrenzte Munition, Pickup); Heilungs-Pickup (+30 HP)
- Klan-Schläger (rennt zu, Stiche) und Wurfkämpfer (Abstand, telegraphierter Wurf)
- Nahkampf bleibt stärker als Fernkampf

**Stufe 4 — Level *Nebliger Wald***
- Layout: Einstieg → Kampfzone 1 → Plattform → Kampfzone 2 → Arena → Ausgang
- Ein Checkpoint (Schrein), Auto-Aktivierung; Respawn mit vollem Leben, Wurfsterne auf Stand bei Aktivierung
- Kein Fallenleger, kein Wasserfall-Puzzle

**Stufe 5 — Boss, Sieg, Intro**
- Klan-Schläger-Hauptmann: erhöhte HP, Stampf-Angriff, Telegraph; Arena schließt sich
- Boss-Lebensbalken; Sieg (Boss tot + Ausgang); Niederlage → Respawn nach ~2 s
- Intro-Cutscene (Silhouette, skipbar); Pause mit Esc

**Stufe 6 — Atmosphäre, HUD, Export**
- HUD: HP oben links, Wurfsterne oben rechts, Boss-Balken nur im Kampf
- Düstere Palette, Parallax; Pixel-Art wo Assets da sind
- HTML5/Web-Export; Playtest-Balancing

---

## 13. Design-Entscheidungen

| Frage | Entscheidung | Auswirkung |
|-------|--------------|------------|
| Lebenssystem | **Lebenspunkte** (100 HP) | Mehrere Treffer erlaubt, Heilungs-Pickups sinnvoll |
| Tod & Wiederholung | **Checkpoints** | Respawn am letzten Checkpoint mit vollem Leben |
| Storytelling | **Cutscenes** | In-Engine-Sequenzen vor/nach Leveln und zwischen Akten |
| Charakter-Progression | **Fester Charakter** | Keine Upgrades — Schwierigkeit nur über Level & Gegner |
| Rauchbombe vs. Fackel | **Fackel neutralisiert Rauch** | Tempel-Wächter Phase 2 — taktischer Counter, kein permanenter Nachteil |
| Block vs. durchdringend | **Armbrust & schwere Schusswaffen ignorieren Block** | Spieler muss Ausweichen lernen — nicht alles ist parierbar |
| Bodenfallen | **Shuriken-Fallen als Gegner-Werkzeug** | Fallenleger in Japan — erweitert Kampf um Positions-Disziplin |

---

## 14. Design-Vorschläge

> **Konzeptbilder:** Alle Visualisierungen liegen unter [`docs/design/`](docs/design/).

### 14.0 Konzeptbilder — Übersicht

| Bereich | Bild | Datei |
|---------|------|-------|
| Spieldesign — Lesbarer Tod | ![Lesbarer Tod](docs/design/design-spieldesign-lesbarer-tod.png) | `design-spieldesign-lesbarer-tod.png` |
| Spieldesign — Nahkampf-Risiko | ![Nahkampf Risiko](docs/design/design-spieldesign-nahkampf-risiko.png) | `design-spieldesign-nahkampf-risiko.png` |
| Spieldesign — Waffen-Priorität | ![Waffen Priorität](docs/design/design-spieldesign-waffen-prioritaet.png) | `design-spieldesign-waffen-prioritaet.png` |
| Spieldesign — Cutscene-Pause | ![Cutscene Pause](docs/design/design-spieldesign-cutscene-pause.png) | `design-spieldesign-cutscene-pause.png` |
| Level — Wald | ![Wald](docs/design/design-level-wald.png) | `design-level-wald.png` |
| Level — Dächer Kyoto | ![Dächer Kyoto](docs/design/design-level-daecher-kyoto.png) | `design-level-daecher-kyoto.png` |
| Level — Neon-Dächer NY | ![Neon Dächer](docs/design/design-level-daecher-neon.png) | `design-level-daecher-neon.png` |
| Level — Chinatown | ![Chinatown](docs/design/design-level-chinatown.png) | `design-level-chinatown.png` |
| Level — U-Bahn | ![U-Bahn](docs/design/design-level-u-bahn.png) | `design-level-u-bahn.png` |
| Level — Hafen im Sturm | ![Hafen](docs/design/design-level-hafen.png) | `design-level-hafen.png` |
| Level — Schiff | ![Schiff](docs/design/design-level-schiff.png) | `design-level-schiff.png` |
| Level — Gipfel (Finale) | ![Gipfel](docs/design/design-level-gipfel.png) | `design-level-gipfel.png` |
| Hafen — Übergang Japan→Westen | ![Übergang](docs/design/design-hafen-uebergang-japan.png) | `design-hafen-uebergang-japan.png` |
| Querschnitt — Checkpoint & Boss | ![Checkpoint Boss](docs/design/design-querschnitt-checkpoint-boss.png) | `design-querschnitt-checkpoint-boss.png` |

### 14.0b In-Game Grafiken (Godot) — Übersicht

> Pixel-Art-Screenshots im Godot-2D-Stil — Ziellook für Tilemaps, Sprites und HUD.

| Szene | Bild | Datei |
|-------|------|-------|
| Level — Nebliger Wald | ![In-Game Wald](docs/design/ingame/ingame-level-wald-godot.png) | `ingame-level-wald-godot.png` |
| Kampf — Nahkampf | ![In-Game Kampf](docs/design/ingame/ingame-combat-nahkampf-godot.png) | `ingame-combat-nahkampf-godot.png` |
| Mechanik — Shuriken-Falle | ![In-Game Falle](docs/design/ingame/ingame-mechanik-shuriken-falle-godot.png) | `ingame-mechanik-shuriken-falle-godot.png` |
| Level — Dächer Kyoto | ![In-Game Kyoto](docs/design/ingame/ingame-level-daecher-kyoto-godot.png) | `ingame-level-daecher-kyoto-godot.png` |
| Level — Neon-Dächer NY | ![In-Game Neon](docs/design/ingame/ingame-level-neon-daecher-godot.png) | `ingame-level-neon-daecher-godot.png` |
| Level — Chinatown | ![In-Game Chinatown](docs/design/ingame/ingame-level-chinatown-godot.png) | `ingame-level-chinatown-godot.png` |
| Level — U-Bahn | ![In-Game U-Bahn](docs/design/ingame/ingame-level-u-bahn-godot.png) | `ingame-level-u-bahn-godot.png` |
| Level — Hafen im Sturm | ![In-Game Hafen](docs/design/ingame/ingame-level-hafen-godot.png) | `ingame-level-hafen-godot.png` |
| Level — Schiff | ![In-Game Schiff](docs/design/ingame/ingame-level-schiff-godot.png) | `ingame-level-schiff-godot.png` |
| Boss — Tempel-Wächter | ![In-Game Boss Tempel](docs/design/ingame/ingame-boss-tempel-waechter-godot.png) | `ingame-boss-tempel-waechter-godot.png` |
| Boss — Finale Gipfel | ![In-Game Boss Finale](docs/design/ingame/ingame-boss-finale-gipfel-godot.png) | `ingame-boss-finale-gipfel-godot.png` |
| HUD / UI | ![In-Game HUD](docs/design/ingame/ingame-hud-ui-godot.png) | `ingame-hud-ui-godot.png` |
| Cutscene — Pause | ![In-Game Cutscene](docs/design/ingame/ingame-cutscene-pause-godot.png) | `ingame-cutscene-pause-godot.png` |

### 14.1 Spieldesign — 5 Vorschläge

#### 1. „Lesbarer Tod“ — Fehler als Lernmoment

Jeder Tod soll dem Spieler **sofort zeigen, wodurch** er getroffen wurde: kurzer Freeze-Frame, rote Silhouette der Waffe, und ein Wiederholungs-Hinweis („Ausweichen bei rotem Laser“). Kein Game Over-Screen mit langer Wartezeit — nach 2 Sekunden Respawn am Checkpoint. So bleibt der Flow erhalten und der Spieler lernt Waffenmuster organisch.

#### 2. Risiko-Belohnung durch Nahkampf

Fernkampf mit Wurfsternen ist sicher, aber **schwächer und begrenzt**. Wer aggressiv mit der Katana in den Nahkampf geht, beendet Kämpfe schneller und spart Munition — riskiert aber mehr Schaden. Diese Spannung hält jeden Kampf interessant, ohne Upgrades zu brauchen.

#### 3. Düstere Stimmung durch Sound-Design

Musik ist **sparsam** — lange Passagen nur mit Umgebungsgeräuschen (Regen, Wind, entfernte Schritte). Boss-Musik setzt erst ein, wenn der Spieler die Arena betritt. In New York dominieren dumpfe Bässe und Neon-Summen statt Melodien. Stille vor dem Kampf erzeugt Anspannung.

#### 4. Cutscenes als Gameplay-Pause

Cutscenes dienen nicht nur der Story, sondern als **atmende Pause** zwischen intensiven Abschnitten. Nach einem schweren Boss folgt eine kurze, stille Sequenz — der Ninja bandagiert seine Wunde, schaut auf die nächste Stadt. Kein Dialog-Overload, nur Bild und Emotion.

#### 5. Waffen-Priorität im HUD

Gegner zeigen **visuell ihre Bedrohung**, bevor sie angreifen: Pistolen-Gegner zücken die Waffe, Sniper-Laser leuchtet 1 Sekunde vor dem Schuss, Axt-Kämpfer holen weit aus, **Shuriken-Fallen leuchten schwach**, **Kettensäge-Minions sind akustisch hörbar** bevor sie sichtbar werden. Der Spieler lernt, wen er zuerst eliminieren muss — ohne explizites Ziel-Markierungssystem.

---

### 14.2 Level-Design — Wald (Japan) — 4 Vorschläge

| Nr. | Vorschlag | Umsetzung |
|-----|-----------|-----------|
| 1 | **Mehrschichtige Tiefe** | Vordergrund-Bäume (halbtransparent), Spiel-Ebene, Hintergrund-Nebel — Parallax erzeugt Tiefe in flachem 2D |
| 2 | **Versteckte Gegner hinter Bambus** | Gegner tauchen erst auf, wenn der Ninja nahe genug ist — Überraschungsmoment, belohnt vorsichtiges Vorgehen |
| 3 | **Wasserfall als natürliche Barriere** | Wasserfall blockiert den Weg — Ninja muss oben herumklettern, während Bogenschützen von der anderen Seite schießen |
| 4 | **Fallende Blätter als Sichtstörung** | In Boss-Arena wirbelt der Wind Blätter auf — kurz schwerer, Projektile zu erkennen (nur visuell, kein unfairer Effekt) |

**Beispiel Level 1 (*Nebliger Wald*):** Einstieg durch verbranntes Dorf (Cutscene-Reste), dann dichter Nebel, erster Kampf gegen 2 Schläger, **Fallenleger legt Shuriken-Fallen** vor dem Checkpoint, Boss-Arena in einer Lichtung.

**Beispiel Level 2 (*Tempel der Asche*):** Dunkle Tempelhallen mit Kerzenlicht, **Fallenleger** in Seitengängen, Boss-Arena erhellt sich in Phase 2 durch **Fackel-Werfer** — Rauchbombe wirkungslos, Ninja muss Nahkampf riskieren.

---

### 14.3 Level-Design — Dächer — 4 Vorschläge

| Nr. | Vorschlag | Umsetzung |
|-----|-----------|-----------|
| 1 | **Abgrund als ständige Bedrohung** | Fehlende Sprünge = Tod — keine unsichtbaren Wände, klare Plattform-Kanten mit Warn-Schatten |
| 2 | **Wind-Böen als Timing-Element** | Alle 8–10 Sekunden Windstoß — springende Gegner und der Ninja werden leicht zurückgedrängt; Sprünge müssen getimed werden |
| 3 | **Kettenhaken-Routen** | Alternative Wege über Dächer — schneller, aber mehr Sniper-Gegner; Bodenroute sicherer, aber länger |
| 4 | **Japan vs. NY visuell trennen** | Japan-Dächer: Holz, rote Ziegel, Mondlicht. NY-Dächer: Beton, Neon-Reklame, Regen auf Metall — gleiche Mechanik, anderer Look |

**Beispiel Level 3 (*Dächer von Kyoto*):** Start auf niedrigem Dach, Sprung-Puzzle nach oben, Schatten-Ninja-Boss auf dem höchsten Tempel-Dach mit Panorama-Hintergrund.

**Beispiel Level 10 (*Neon-Dächer*):** Regen, blinkende Neon-Schilder, Sniper von gegenüberliegendem Hochhaus — Spieler muss im Rhythmus der Lichtblitze vorrücken. **Dach-Elite** mit Armbrust erzwingt Ausweichen statt Blocken.

---

### 14.4 Level-Design — Stadt (New York) — 5 Vorschläge

| Nr. | Vorschlag | Umsetzung |
|-----|-----------|-----------|
| 1 | **Neon als Lichtquelle** | Neon-Schilder beleuchten Bereiche — Ninja in Schatten schwerer zu treffen, unter Neon leicht erkennbar |
| 2 | **Enge Gassen vs. offene Straßen** | Chinatown: enge Gänge, Nahkampf dominiert. Wall Street: breite Straßen, Söldner mit Sturmgewehren auf Dächern |
| 3 | **Interaktive Umgebung** | Umgestoßene Mülltonnen blockieren kurz Projektile; kaputte Straßenlaternen erzeugen Funken (visuell, kein Gameplay-Effekt) |
| 4 | **U-Bahn als Horror-Level** | Fast komplett dunkel — nur Lichtkegel der Ninja-Fackel und entfernte Zuglichter. Gegner tauchen aus Schatten auf |
| 5 | **Vertikale Wolkenkratzer-Ebenen** | Level 12 (*Der Gipfel*): Aufzug-Schacht, Treppenhaus, Dach — drei vertikale Abschnitte statt horizontalem Scrollen |

**Beispiel Level 8 (*Chinatown*):** Enge Gasse mit roten Laternen, Gangmitglieder mit Baseballschlägern, Boss-Kampf auf einem Wochenmarkt mit umgestürzten Ständen als Deckung.

**Beispiel Level 11 (*Wall Street*):** Breite Straßen, **Kettensäge-Minions** als akustische Bedrohung (Motor-Geräusch hörbar bevor Gegner sichtbar), Klan-Elite-Boss mit Dual-Pistolen Phase 1.

**Beispiel Level 12 (*Der Gipfel*):** Vertikaler Aufstieg, finale Arena auf dem Dach — **Anführer des Schwarzen Klans** mit **Ninjato (gebrochene Klinge)**: 4-Hieb-Combos schneller als Spieler-Katana, erfordert perfektes Ausweichen-Timing.

**Beispiel Level 9 (*U-Bahn-Schatten*):** Fahrende U-Bahn im Hintergrund (Parallax), Gasgranaten reduzieren Sichtfeld, Schrotflinten-Gegner lauern hinter Säulen.

---

### 14.5 Level-Design — Hafen & Schiff — 3 Vorschläge

| Nr. | Vorschlag | Umsetzung |
|-----|-----------|-----------|
| 1 | **Sturm-Physik auf dem Deck** | Level 6 (*Über dem Meer*): Plattform kippt leicht mit Wellengang — Sprünge und Timing erschwert, Harpunen fliegen unregelmäßiger |
| 2 | **Regen und Wellen als Atmosphäre** | Level 5 (*Hafen im Sturm*): Starker Regen, Kran-Haken als Plattformen, Hafen-Meister-Boss auf einem schwankenden Steg |
| 3 | **Übergang Japan → Westen** | Cutscene beim Verlassen des Hafens: Ninja blickt zurück auf Japan (Silhouette), dann schwarzer Bildschirm — Ankunft in NY |

---

### 14.6 Level-Design — Querschnitt (alle Level-Typen) — 4 Vorschläge

| Nr. | Vorschlag | Umsetzung |
|-----|-----------|-----------|
| 1 | **Checkpoint als visueller Marker** | Japan: kleiner Schrein mit brennender Kerze. NY: kaputte Straßenlaterne. Einheitlich erkennbar, regional unterschiedlich |
| 2 | **Boss-Arena immer abgetrennt** | Vor dem Boss: automatisches Tor schließt sich — kein Zurück, kurzer Versorgungsabschnitt mit Heilung und Wurfsternen |
| 3 | **Level-Dauer 5–10 Minuten** | Kurze, fokussierte Abschnitte — kein Padding. Lieber 12 dichte Level als 6 lange |
| 4 | **Geheime Kurzwege** | Optionaler oberer Pfad mit mehr Gegnern aber schnellerem Fortschritt — belohnt erfahrene Spieler ohne zu bestrafen |

---

## 15. Referenzen & Inspiration

- *Shinobi* (Arcade) — 2D-Ninja-Action, Side-Scroller
- *Ninja Gaiden* — Herausfordernder Schwertkampf
- *Katana ZERO* — Düstere Ästhetik, präzises Kampfdesign
- *Hollow Knight* — Atmosphäre, Boss-Design
- *Ghost of Tsushima* — Japan-Setting, Samurai/Ninja-Fantasie
- *Max Payne* — Düstere Großstadt, Rache-Erzählung

---

*Dokument erstellt als Grundlage für die Entwicklung von Ninja Assassin.*
