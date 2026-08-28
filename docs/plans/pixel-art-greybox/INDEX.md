# pixel-art-greybox

**Typ:** Feature
**Status:** in Umsetzung
**Worktree:** `task/pixel-art-greybox` (Pfad `.worktrees/pixel-art-greybox`)

## Ziel

Bestehende Greybox-ColorRects (Ninja, Boden, 3 Plattformen, Hintergrund) in hochauflösender Pixel-Art im Stil des Hafen-Mockups einkleiden; Spieler animiert für Idle/Run/Jump/Fall/Dodge; auf 30"-4K lesbar (1280×720 beibehalten, mehr Sprite-Pixel, Ninja ~2× so groß auf dem Bildschirm).

## Metrik

Headless-Tests grün (`bash scripts/godot.sh --headless --path . -s tests/run_tests.gd`); AnimatedSprite2D + Tiles/Hintergrund im Spiel sichtbar; Animationsnamen existieren; Kollision funktioniert weiter.

## Scope

- `assets/` PNG-Sprites und 32px-Pier-Tiles, Nearest-Neighbor-Import
- Spieler: 64×80-Canvas, Kollision ~32×64, AnimatedSprite2D statt ColorRects; Idle 4–6, Run 6–8, Jump 2–3, Fall 2, Dodge 4–6; Katana nur visuell; i-Frame-Modulate beibehalten; Flip mit Blickrichtung
- Boden: 32×32-Tiles, zwei Tiles hoch (64px), 2400px Laufstrecke, Kollisionshöhe 64
- Plattformen: gleiches Tileset, ein Tile hoch 32px, X 320/620/980, Breiten snappen 176/160/192
- Hintergrund: 2-Layer-Parallax Hafensturm + Regen (Vorlage `docs/design/ingame/ingame-level-hafen-godot.png`)
- Integer-Window-Stretch für 4K (1280×720 ×3)
- Physik-Konstanten beibehalten, außer späterer Playtest etwas anderes verlangt

## Out of scope

- Attack-/Throw-/Hurt-/Death-Animationen
- Gegner, HUD, Pickups, Schrein
- Volles Nebliger-Wald-Tileset
- NY-Palette
- Combat-VFX
- Run-/Jump-/Dodge-Zahlen ändern, außer Playtest
- Diese Aufgabe schließt KONZEPT Stufe 6 **nicht** ab

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-greybox-pixel-art.md` | Greybox Pixel Art | implementiert |

## Fortschritt (MVP-Stufen)

Übergeordnet: KONZEPT.md §12.1. Diese Aufgabe ist ein früher, dünner Vorgriff auf Greybox-Art (Atmosphäre), **nicht** der Abschluss von Stufe 6. Stufe 6 bleibt `offen`. Parent muss KONZEPT-Roadmap, Cursor-Plan und Canvas synchron halten.

| Stufe | Name | Plan | Status |
|-------|------|------|--------|
| 1 | Steuerung & Greybox | `docs/plans/mvp-steuerung/` | erledigt |
| 2 | Nahkampf & Leben | — | offen |
| 3 | Fernkampf & Gegner | — | offen |
| 4 | Level Nebliger Wald | — | offen |
| 5 | Boss, Sieg, Intro | — | offen |
| 6 | Atmosphäre, HUD, Export | — | offen |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten

Cursor-Plan „Greybox Pixel Art“ am 2026-08-28 zur Implementierung freigegeben.
