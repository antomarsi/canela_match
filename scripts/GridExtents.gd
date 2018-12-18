tool
extends Node2D

class_name GridExtents

export var size : Vector2 = Vector2(40, 40) setget set_size
export var color : Color = Color("#FF0EA7") setget set_color
export var offset : Vector2 setget set_offset
export var piece_size : Vector2 = Vector2(64, 64) setget set_piece_size

var _rect : Rect2
export var width : int = 10 setget set_width
export var height : int = 8 setget set_height

func set_width(value:int) -> void:
	size.x = piece_size.x * value
	update()

func set_height(value:int) -> void:
	size.y = piece_size.y * value
	update()

func set_piece_size(value: Vector2) -> void:
	piece_size = value
	update()

func set_size(value : Vector2) -> void:
	size = value
	_recaculate_rect()
	update()

func set_color(value : Color) -> void:
	color = value
	update()

func set_offset(value : Vector2) -> void:
	offset = value
	_recaculate_rect()
	update()

func _recaculate_rect():
	_rect = Rect2(-1.0 * size / 2 + offset, size)
	var size : Vector2 = _rect.size
	if size.x == 0:
		width = 0
	elif piece_size.x > 0:
		width = int(size.x / piece_size.x)
	if size.y == 0:
		height = 0
	elif piece_size.y > 0:
		height = int(size.y / piece_size.y)

func _draw() -> void:
	if not Engine.editor_hint:
		return
	draw_rect(_rect, color, false)

func has_point(point : Vector2) -> bool:
	var rect_global = Rect2(global_position + _rect.position, _rect.size)
	return rect_global.has_point(point)

func grid_to_pixel(column, row):
	var pos = global_position + _rect.position
	var new_x = pos.x + (piece_size * column)
	var new_y = pos.y - (piece_size * row)
	return Vector2(new_x, new_y)