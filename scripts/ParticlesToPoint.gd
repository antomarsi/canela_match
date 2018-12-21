extends Node2D

export var spritePath : PackedScene
var value = 0

func spawn_particles(start_pos : Vector2, end_pos : Vector2, quantity : int, color : Color):
	randomize()
	for i in range(quantity):
		var s = spritePath.instance()
		s.set_color(color)
		s.global_position = start_pos
		s.connect("finished", self, "add_value")
		s.dest = end_pos
		print("spawn")
		add_child(s)
	pass