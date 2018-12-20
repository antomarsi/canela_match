extends Node2D
#The Grid
onready var grid = $GridExtends
# The possible pieces
export (Array, PackedScene) var possible_pieces : Array;
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
	pass # Replace with function body.

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
	if not grid.in_grid(start_position):
		return
	var piece_in_grid = grid.pixel_to_grid(start_position)
	var other_piece = piece_in_grid + direction
	if other_piece.x <= grid.width-1 and other_piece.y <= grid.height-1 and other_piece.x >= 0 and other_piece.y >= 0:
		swap_pieces(piece_in_grid.x, piece_in_grid.y, direction)

func swap_pieces(column : int, row : int, direction : Vector2) -> void:
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	all_pieces[column][row] = other_piece
	all_pieces[column + direction.x][row + direction.y] = first_piece
	first_piece.move(grid.grid_to_pixel(column + direction.x, row + direction.y))
	other_piece.move(grid.grid_to_pixel(column, row))
