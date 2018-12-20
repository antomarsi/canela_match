tool
extends Node2D

class_name GridExtents

export var color : Color = Color("#FF0EA7") setget set_color
export var piece_size : Vector2 = Vector2(64, 64) setget set_piece_size

var _rect : Rect2
export var width : int = 10 setget set_width
export var height : int = 8 setget set_height

func set_piece_size(value: Vector2) -> void:
	piece_size = value
	update()

func set_width(value : int) -> void:
	width = value
	_recaculate_rect()
	update()

func set_height(value : int) -> void:
	height = value
	_recaculate_rect()
	update()

func set_color(value : Color) -> void:
	color = value
	update()

func _recaculate_rect():
	_rect = Rect2(Vector2(0, 0), Vector2(piece_size.x * width, - (piece_size.y * height)))

func _draw() -> void:
	if not Engine.editor_hint:
		return
	draw_rect(_rect, color, false)

func has_point(point : Vector2) -> bool:
	var rect_global = Rect2(global_position + _rect.position, _rect.size)
	return rect_global.has_point(point)

func in_grid(position : Vector2) -> bool:
	var vec = global_position
	vec.y = vec.y - (piece_size.y * height)
	var rect = Rect2(vec, Vector2(piece_size.x * width, piece_size.y * height))
	return rect.has_point(position)

func grid_to_pixel(column : int, row : int) -> Vector2:
	var new_x = _rect.position.x + (piece_size.x * column) + (piece_size.x / 2)
	var new_y = _rect.position.y - (piece_size.y * row) - (piece_size.y / 2)
	return Vector2(new_x, new_y)

func pixel_to_grid(position : Vector2) -> Vector2:
	var new_x = int((position.x - global_position.x) / piece_size.x)
	var new_y = -int((position.y - global_position.y) / piece_size.y)
	return Vector2(new_x, new_y)