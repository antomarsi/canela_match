extends Node2D

export (PackedScene) var ghost_scene;

enum CELL_TYPE { UNFILED, FILLED, END, ACTOR }
enum COLOR { PURPLE, BLUE, YELLOW, RED }

signal reached_end(pivot)

export (CELL_TYPE) var type = CELL_TYPE.ACTOR
export (COLOR) var color = COLOR.PURPLE

onready var Grid : TileMap = get_parent()
onready var piece = $Pivot
onready var sprite = $Pivot/Sprite
onready var anim : AnimationPlayer = $Pivot/AnimationPlayer
onready var line : Line2D = $Line2D

func _ready():
	line.add_point(piece.position)
	line.default_color = piece.get_node("Sprite").modulate
	pass

func get_piece_position() -> Vector2:
	return piece.global_position;

func _process(delta):
	var input_direction = get_input_direction()
	if input_direction == Vector2.ZERO:
		return
	var target_position = Grid.request_move(piece.global_position, input_direction)
	if target_position and target_position != piece.global_position:
		move_to(target_position)
	else:
		bump()

func get_input_direction() -> Vector2:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), 0)
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		return Vector2(0, int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	return Vector2.ZERO

func set_active(value:bool) -> void:
	set_process(value)
	if value:
		anim.play("Active")
	else:
		anim.play("idle")
	
func bump() -> void:
	$Bump.play()
	set_process(false)
	anim.play("Bump")
	yield(anim, "animation_finished")
	anim.play("Active")
	set_process(true)
	pass

func move_to(target_position) -> void:
	$Move.play()
	$GhostTimer.start()
	target_position = to_local(target_position)
	set_process(false)
	$Tween.interpolate_property(piece, "position", piece.position, target_position, 0.3,Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	line.add_point(piece.position)
	yield($Tween, "tween_completed")
	line.set_point_position(line.get_point_count()-1, target_position)
	$GhostTimer.stop()
	set_process(true)
	var end = Grid.get_end_in_position(piece.global_position)
	if end != null and end.color == color:
		emit_signal("reached_end", self)
		$End.play()

func _on_Tween_tween_step(object, key, elapsed, value):
	line.set_point_position(line.get_point_count()-1, value)
	pass

func _on_GhostTimer_timeout():
	var ghost = ghost_scene.instance()
	ghost.modulate = sprite.modulate
	ghost.scale = sprite.scale
	ghost.texture = sprite.texture
	get_parent().add_child(ghost)
	ghost.global_position = piece.global_position