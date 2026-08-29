# enemy-contrast

**Typ:** Verbesserung
**Status:** erledigt
**Worktree:** `task/enemy-contrast` (Pfad `.worktrees/enemy-contrast`)

## Ziel

Dummy, Schläger und Wurfkämpfer als Greybox-ColorRects gegen die Hafen-Nacht lesbar und voneinander unterscheidbar.

## Metrik

`bash scripts/run-tests.sh` grün; Idle-Luminanz über `MIN_IDLE_LUMINANCE`; die drei Idle-Farben paarweise klar verschieden; Outline-Node in den drei Szenen.

## Scope

- Outline ColorRect (~4 px größer) hinter `Body` in Dummy, ClanThug, ThrowFighter
- Hellere saturierte `COLOR_IDLE` + Band in Scripts und `.tscn`
- Collision 24×40 unverändert
- Headless-Tests aus Script-Konstanten

## Out of scope

- Pixel-Art-Sprites (KONZEPT Stufe 6)
- KI, Schaden, Hitbox-Größen
- `JUMP_*` / Dodge / Combo
- ColorRects in `level_greybox.tscn`
- Checkpoint/Pickup-Look

## Slices

| Datei | Titel | Status |
|-------|--------|--------|
| `01-placeholder-contrast.md` | Outline und Idle-Farben | implementiert |

## Freigabe

- [x] User hat INDEX und Slice-Dateien freigegeben
- [x] Implementierung darf starten
