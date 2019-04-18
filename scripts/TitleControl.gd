extends Control

export (PackedScene) var ghost_scene
onready var sprite = $TextureRect

func _ready():
	$TextureRect.visible = false
	$Label.visible = false
	$Button.visible = false
	$TextureRect2.modulate = Color(0,0,0,0)

func play():
	$TextureRect.visible = true
	$AudioStreamPlayer.play()
	$TextureRect/AnimationPlayer.play("in")
	$Timer.start(0.1)

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.stop()
	$Label.visible = true
	$Label/AnimationPlayer.play("blink")
	get_parent().can_go_to_new_scene = true
	$Button.visible = true

func _on_Timer_timeout():
	var ghost = ghost_scene.instance()
	ghost.texture = sprite.texture
	ghost.rect_global_position = sprite.rect_global_position
	ghost.rect_size = sprite.rect_scale
	ghost.margin_bottom = sprite.margin_bottom
	ghost.margin_left = sprite.margin_left
	ghost.margin_right = sprite.margin_right
	ghost.margin_top = sprite.margin_top
	add_child(ghost)

func _on_Button_pressed():
	OS.shell_open("https://steviasphere.bandcamp.com/")
