extends TileMap

enum CELL_TYPE { UNFILED, FILLED, END, ACTOR }

signal map_is_full

func _ready():
	for node in get_children():
		if node.get("type") and node.type == CELL_TYPE.ACTOR:
			var cell_pos = world_to_map(node.position)
			set_cellv(cell_pos, CELL_TYPE.FILLED)
			update_bitmask_area(cell_pos)
	pass # Replace with function body.

func is_map_full() -> bool:
	var used_cells = get_used_cells()
	for cell_pos in used_cells:
		var cell = get_cellv(cell_pos)
		if cell == CELL_TYPE.UNFILED:
			return false
	return true
	
func get_end_in_position(pos):
	for node in get_children():
		if node.get("type") and node.type == CELL_TYPE.END and node.global_position == pos:
			return node
	return null

func request_move(piece_pos, direction):
	var cell_start = world_to_map(piece_pos)
	print(piece_pos)
	var cell_target = cell_start + direction
	var cell_id = get_cellv(cell_target)
	while cell_id == CELL_TYPE.UNFILED:
		set_cellv(cell_target, CELL_TYPE.FILLED)
		update_bitmask_area(cell_target)
		cell_target = cell_target + direction
		cell_id = get_cellv(cell_target)
	cell_target = cell_target - direction
	return map_to_world(cell_target) + cell_size / 2