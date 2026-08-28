extends Node2D

const SOURCE_ID := 0
const FLOOR_COLS := 75
const FLOOR_ORIGIN := Vector2i(-7, 12)
const PLATFORMS := [
	{"origin": Vector2i(6, 10), "cols": 6, "atlas": Vector2i(2, 0)},
	{"origin": Vector2i(16, 9), "cols": 5, "atlas": Vector2i(3, 0)},
	{"origin": Vector2i(27, 9), "cols": 6, "atlas": Vector2i(2, 0)},
]


func _ready() -> void:
	var tiles: TileMapLayer = $Tiles
	_fill_floor(tiles)
	for platform: Dictionary in PLATFORMS:
		_fill_row(
			tiles,
			platform["origin"],
			int(platform["cols"]),
			platform["atlas"]
		)


func _fill_floor(tiles: TileMapLayer) -> void:
	for x in FLOOR_COLS:
		var deck := Vector2i(x % 2, 0)
		var support := Vector2i(x % 2, 1)
		tiles.set_cell(FLOOR_ORIGIN + Vector2i(x, 0), SOURCE_ID, deck)
		tiles.set_cell(FLOOR_ORIGIN + Vector2i(x, 1), SOURCE_ID, support)


func _fill_row(tiles: TileMapLayer, origin: Vector2i, cols: int, atlas: Vector2i) -> void:
	for x in cols:
		var cell := atlas
		if x % 2 == 1:
			cell.x = mini(cell.x + 1, 3)
		tiles.set_cell(origin + Vector2i(x, 0), SOURCE_ID, cell)
