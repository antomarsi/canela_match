extends Sprite

func _ready():
	var modulate_opaque = modulate
	modulate_opaque.a = 0
	$AlphaTween.interpolate_property(self, "modulate", modulate, modulate_opaque, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$AlphaTween.start()
	pass # Replace with function body.

func _on_AlphaTween_tween_completed(object, key):
	queue_free()
