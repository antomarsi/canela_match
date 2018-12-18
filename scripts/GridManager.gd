extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var grid = $Grid
export (Array, PackedScene) var possible_pieces : Array;
var all_pieces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	all_pieces = make_2d_array()
	pass # Replace with function body.

func make_2d_array():
	var array = [];
	for i in grid.width:
		array.append([])
		for j in grid.height:
			array[i].append(null)
	return array

func spawn_pieces():
	for column in grid.width:
		for row in grid.height:
			var rand = randi() % possible_pieces.size()
			print(rand)
			var piece = possible_pieces[rand].instance()
			add_child(piece)
			piece.position = grid.grid_to_pixel(column, row)
