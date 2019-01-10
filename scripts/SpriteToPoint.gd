extends Path2D

signal finished

onready var tween = $Tween
onready var path_follow = $PathFollow2D
var dest : Vector2

func set_color(color : Color):
	$PathFollow2D/SpriteToPoint.modulate = color

func _ready():
	curve.add_point(Vector2(0, 0))
	var direction = (position - dest).normalized()
	direction.y += rand_range(-0.5, 0.5)
	var distance = rand_range(50, 150)
	var rand1 = rand_range(-150, 150)
	var rand2 = rand_range(70, -70)
	curve.add_point(direction * distance, Vector2(rand1, rand2), Vector2(-rand1, -rand2))
	curve.add_point(dest - global_position)
	tween.interpolate_property(path_follow, "unit_offset", 0, 1, rand_range(0.5, 1), Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	emit_signal("finished", 1)
	queue_free()