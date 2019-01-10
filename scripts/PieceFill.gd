tool
extends Node2D

signal full

const COLOR = {
	BLUE = 0,
	PURPLE = 1,
	GREEN = 2,
	RED = 3,
	YELLOW = 4
}

export (Texture) var texture = null setget setTexture
export (COLOR) var colorType = COLOR.BLUE
onready var progress_bar = $ProgressBar
onready var tween = $Tween

var current_value = 0
var max_value = 100

func setTexture( value : Texture ):
	texture = value
	if Engine.is_editor_hint() and value:
		$TextureRect.texture = texture
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = texture
	progress_bar.value = current_value
	progress_bar.max_value = max_value

func add_value(value):
	if current_value == max_value:
		return
	current_value += value
	clamp(current_value, 0, max_value)
	if current_value == max_value:
		emit_signal("full", colorType)
	tween.interpolate_property(progress_bar, "value", progress_bar.value, current_value, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	