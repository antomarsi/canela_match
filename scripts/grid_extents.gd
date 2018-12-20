tool
extends Node2D

class_name GridExtents

export var size : Vector2 = Vector2(40, 40) setget set_size
export var color : Color = Color("#FF0EA7") setget set_color
export var offset : Vector2 setget set_offset
export var piece_size : Vector2 = Vector2(64, 64) setget set_piece_size

var _rect : Rect2
var width : int
var height : int

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

func in_grid(position : Vector2) -> bool:
	var rect = Rect2(global_position + _rect.position, Vector2(piece_size.x * width, piece_size.y * height))
	return rect.has_point(position)

func grid_to_pixel(column : int, row : int) -> Vector2:
	var new_x = _rect.position.x + (piece_size.x * column) + (piece_size.x / 2)
	var new_y = _rect.position.y + (piece_size.y * row) + (piece_size.y / 2)
	return Vector2(new_x, new_y)

func pixel_to_grid(position : Vector2) -> Vector2:
	var new_x = int((position.x - (global_position.x + _rect.position.x)) / piece_size.x)
	var new_y = int((position.y - (global_position.y + _rect.position.y)) / piece_size.y)
	return Vector2(new_x, new_y)