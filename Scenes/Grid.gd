extends Node2D

export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;
export (Array, PackedScene) var pieces;

var all_pieces = []

func _ready():
	all_pieces = make_2d_array()
	pass

func make_2d_array():
	var array = [];
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array