extends Node2D
#The Grid
signal pieces_destroyed (pieces_destroyed)
onready var grid = $GridExtends
# The possible pieces
export (Array, PackedScene) var possible_pieces : Array = [
	preload("res://scenes/Pieces/BluePiece.tscn"),
	preload("res://scenes/Pieces/RedPiece.tscn"),
	preload("res://scenes/Pieces/GreenPiece.tscn"),
	preload("res://scenes/Pieces/PurplePiece.tscn"),
	preload("res://scenes/Pieces/YellowPiece.tscn"),
]
# The current pieces in the scene
var all_pieces = []

# Touch Variables
var selected_piece : Piece
var final_piece : Piece

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	all_pieces = make_2d_array()
	spawn_pieces()
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_touch"):
		print(grid.pixel_to_grid(get_global_mouse_position()))

func make_2d_array():
	var array = [];
	for i in grid.width:
		array.append([])
		for j in grid.height:
			array[i].append(null)
	return array
	
func match_at(column : int, row : int, color : int) -> bool:
	if column > 1:
		if all_pieces[column - 1][row] != null && all_pieces[column - 2][row] != null:
			if all_pieces[column - 1][row].color == color && all_pieces[column - 2][row].color == color:
				return true
	if row > 1:
		if all_pieces[column][row - 1] != null && all_pieces[column][row - 2] != null:
			if all_pieces[column][row - 1].color == color && all_pieces[column][row - 2].color == color:
				return true
	return false

func spawn_pieces():
	for column in grid.width:
		for row in grid.height:
			var rand = floor(rand_range(0, possible_pieces.size()))
			var loops = 0
			var piece = possible_pieces[rand].instance()
			while (match_at(column, row, piece.color) && loops < 100):
				rand = floor(rand_range(0, possible_pieces.size()))
				loops += 1
				piece = possible_pieces[rand].instance()
			grid.get_node("Pieces").add_child(piece)
			piece.position = grid.grid_to_pixel(column, row)
			all_pieces[column][row] = piece

func _on_SwipeDetector_swiped(start_position : Vector2, direction : Vector2) -> void:
	print("swipe")	
	if not grid.in_grid(start_position):
		return
	print("in_grid")
	var piece_in_grid = grid.pixel_to_grid(start_position)
	var other_piece = piece_in_grid + direction
	print(piece_in_grid)
	print(other_piece)
	if other_piece.x < grid.width and other_piece.y < grid.height and other_piece.x >= 0 and other_piece.y >= 0:
		swap_pieces(piece_in_grid.x, piece_in_grid.y, direction)

func swap_pieces(column : int, row : int, direction : Vector2) -> void:
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	if first_piece == null or other_piece == null:
		return
	all_pieces[column][row] = other_piece
	all_pieces[column + direction.x][row + direction.y] = first_piece
	first_piece.move(grid.grid_to_pixel(column + direction.x, row + direction.y))
	other_piece.move(grid.grid_to_pixel(column, row))
	find_matches()

func find_matches() -> void:
	for i in grid.width:
		for j in grid.height:
			if all_pieces[i][j] != null:
				var current_color = all_pieces[i][j]
				if i > 0 and i < grid.width - 1:
					if all_pieces[i-1][j] != null && all_pieces[i+1][j] != null:
						if all_pieces[i-1][j].color == current_color.color and all_pieces[i+1][j].color == current_color.color:
							all_pieces[i-1][j].matched = true
							all_pieces[i-1][j].dim()
							all_pieces[i][j].matched = true
							all_pieces[i][j].dim()
							all_pieces[i+1][j].matched = true
							all_pieces[i+1][j].dim()
				if j > 0 and j < grid.height - 1:
					if all_pieces[i][j-1] != null && all_pieces[i][j+1] != null:
						if all_pieces[i][j-1].color == current_color.color and all_pieces[i][j+1].color == current_color.color:
							all_pieces[i][j-1].matched = true
							all_pieces[i][j-1].dim()
							all_pieces[i][j].matched = true
							all_pieces[i][j].dim()
							all_pieces[i][j+1].matched = true
							all_pieces[i][j+1].dim()
	$DestroyTimer.start()

func destroy_matched():
	var destroyed = []
	for i in grid.width:
		for j in grid.height:
			if all_pieces[i][j] != null and all_pieces[i][j].matched:
				destroyed.append({
					"color": all_pieces[i][j].getColor(),
					"pos": all_pieces[i][j].global_position
				});
				all_pieces[i][j].queue_free()
				all_pieces[i][j] = null
	if destroyed.size() > 0:
		$CollapseTimer.start()
		emit_signal("pieces_destroyed", destroyed)
	

func _on_DestroyTimer_timeout():
	destroy_matched()

func collapse_columns():
	for i in grid.width:
		for j in grid.height:
			if all_pieces[i][j] == null:
				for k in range(j + 1, grid.height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid.grid_to_pixel(i, j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	pass

func _on_CollapseTimer_timeout():
	collapse_columns()
	find_matches()
	pass