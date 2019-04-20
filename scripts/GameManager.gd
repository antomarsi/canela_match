extends Node2D

export (String) var next_level
onready var Grid = $TileMap
enum CELL_TYPE { UNFILED, FILLED, END, ACTOR }
var pieces = []
var can_restart = false

func _ready():
	$Transition/AnimationPlayer.play("transition_in")
	for node in Grid.get_children():
		if node.type == CELL_TYPE.ACTOR:
			pieces.append(node)
			node.connect("reached_end", self, "pivot_reched_end")
			node.set_process(false)
	if not pieces.empty():
		pieces[0].set_active(true)
	yield($Transition/AnimationPlayer, "animation_finished")
	can_restart = true

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.scancode == KEY_R and can_restart:
            reset_level()

func pivot_reched_end(pivot):
	pivot.set_active(false)
	pieces.erase(pivot)
	if pieces.empty():
		if Grid.is_map_full():
			next_level()
		else:
			game_over()
	else:
		pieces[0].set_active(true)

func game_over():
	print("Game Over")
	
func reset_level():
	can_restart = false
	$Transition/AnimationPlayer.play("transition_out")
	yield($Transition/AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()

func next_level():
	set_process(false)
	$Music.fade_out()
	$Transition/AnimationPlayer.play("transition_out")
	yield($Transition/AnimationPlayer, "animation_finished")
	get_tree().change_scene(next_level)