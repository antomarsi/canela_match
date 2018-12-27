extends Node2D

signal full

export var texture : Texture
onready var progress_bar = $ProgressBar
onready var tween = $Tween
var current_value = 0
var max_value = 0
var color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = texture
	progress_bar.value = current_value
	progress_bar.max_value = max_value
	pass # Replace with function body.

func add_value(value):
	if current_value == max_value:
		return
	current_value += current_value
	clamp(current_value, 0, max_value)
	if current_value == max_value:
		emit_signal("full", color)
	tween.interpolate_property(progress_bar, "value", progress_bar.value, current_value, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	