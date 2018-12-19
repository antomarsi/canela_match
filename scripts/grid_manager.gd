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
			