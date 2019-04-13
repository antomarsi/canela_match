extends Node2D

export (PackedScene) var next_level
onready var Grid = $TileMap
enum CELL_TYPE { UNFILED, FILLED, END, ACTOR }
var pieces = []

func _ready():
	print("START LEVEL")
	$Transition/AnimationPlayer.play("transition_in")
	for node in Grid.get_children():
		if node.type == CELL_TYPE.ACTOR:
			pieces.append(node)
			node.connect("reached_end", self, "pivot_reched_end")
			node.set_process(false)

	if not pieces.empty():
		pieces[0].set_active(true)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		reset_level()

func pivot_reched_end(pivot):
	pivot.set_active(false)
	pieces.erase(pivot)
	if pieces.empty():
		if Grid.is_map_full():
			next_level()
		else:
			game_over()

func game_over():
	set_process(false)
	print("Game Over")
	
func reset_level():
	set_process(false)
	get_tree().reload_current_scene()
	pass

func next_level():
	set_process(false)
	$Transition/AnimationPlayer.play("transition_out")
	yield($Transition/AnimationPlayer, "animation_finished")
	print("go to next level")
	get_tree().change_scene_to(next_level)