extends Control

export (String) var next_scene

onready var timer = $"../Timer"
onready var tween = $"../Tween"
onready var sound = $"../Blip"
onready var black_rect = $"../ColorRect"
onready var texts = [
		$VBoxContainer/FirstText,
		$VBoxContainer/Thanks,
		$VBoxContainer/Credits,
		$VBoxContainer/Art_code,
		$VBoxContainer/Art_code2,
		$VBoxContainer/Ocs
	]
var finished = false
var index = 0
var last_value = 0

func _ready():
	for node in texts:
		node.visible_characters = 0

func _process(delta):
	set_process(false)
	for text in texts:
		timer.start(0.5)
		yield(timer, "timeout")
		tween.interpolate_property(text, "visible_characters", 0, text.get_total_character_count(), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
		tween.start()
		yield(tween, "tween_completed")
	timer.start(3)
	yield(timer, "timeout")
	$"../Music".fade_out()
	tween.interpolate_property(black_rect, "color", Color(0,0,0,0), Color(0,0,0,1), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	get_tree().change_scene(next_scene)

func _on_Tween_tween_step(object, key, elapsed, value):
	if object != black_rect and last_value != int(value):
		last_value = int(value)
		sound.play()
