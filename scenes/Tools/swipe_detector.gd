tool
extends Node

signal swiped(start_position, direction)
signal swiped_cancel(start_position)

export (float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE : float = 1.3

onready var timer = $Timer
var swipe_start_position = Vector2()

func _input(event) -> void:
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position : Vector2) -> void:
	swipe_start_position = position
	timer.start()

func _end_detection(position : Vector2):
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return 
	if abs(direction.x) > abs(direction.y):
		emit_signal("swiped", swipe_start_position,  Vector2(sign(direction.x), 0))
	if abs(direction.x) < abs(direction.y):
		emit_signal("swiped", swipe_start_position, Vector2(0, sign(direction.y)))

func _on_Timer_timeout():
	emit_signal("swiped_cancel", swipe_start_position)