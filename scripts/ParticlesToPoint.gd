extends Node2D

export var spritePath : PackedScene
var value = 0

func _ready():
	randomize()

func spawn_particles(start_pos : Vector2, end_pos : Vector2, quantity : int, color : Color, node_callback = null):
	for i in range(quantity):
		var s = spritePath.instance()
		s.set_color(color)
		s.global_position = start_pos
		if node_callback != null:
			s.connect("finished", node_callback, "add_value")
		s.dest = end_pos
		add_child(s)
	pass
