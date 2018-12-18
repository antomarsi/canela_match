tool
extends EditorPlugin

enum Anchors {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

var grid_extents : GridExtents
var anchors : Array
var dragged_anchor : Dictionary = {}

const CIRCLE_RADIUS : float = 6.0
const STROKE_RADIUS : float = 2.0
const STROKE_COLOR = Color("#F50956")
const FILL_COLOR = Color("#FFFFFF")
const SQUARE_COLOR : Array = [Color(1, 1, 1, 0.5),  Color(0.5, 0.5, 0.5, 0.5)]

func edit(object : Object) -> void:
	grid_extents = object

func make_visible(visible : bool) -> void:
	"""
	Called when the editor is requested to become visible
	"""
	if not grid_extents:
		return
	if not visible:
		grid_extents = null
	update_overlays()

func handles(object : Object) -> bool:
	return object is GridExtents

func forward_canvas_draw_over_viewport(overlay: Control) -> void:
	"""
	Calculate the 4 anchor positions and bounding rectangles
	from the selected RectExtents node and draw them as circles
	over the viewport
	"""
	if not grid_extents or not grid_extents.is_inside_tree():
		return
	
	var pos = grid_extents.position
	var offset = grid_extents.offset
	var half_size : Vector2 = grid_extents.size / 2.0
	var edit_anchors : = {
		Anchors.TOP_LEFT: pos - half_size + offset,
		Anchors.TOP_RIGHT: pos + Vector2(half_size.x, -1.0 * half_size.y) + offset,
		Anchors.BOTTOM_LEFT: pos + Vector2(-1.0 * half_size.x, half_size.y) + offset,
		Anchors.BOTTOM_RIGHT: pos + half_size + offset,
	}

	var transform_viewport : = grid_extents.get_viewport_transform()
	var transform_global : = grid_extents.get_canvas_transform()
	anchors = []
	var anchor_size : Vector2 = Vector2(CIRCLE_RADIUS * 2.0, CIRCLE_RADIUS * 2.0)
	for coord in edit_anchors.values():
		var anchor_center : Vector2 = transform_viewport * (transform_global * coord)
		var new_anchor = {
			'position': anchor_center,
			'rect': Rect2(anchor_center - anchor_size / 2.0, anchor_size),
		}
		draw_anchor(new_anchor, overlay)
		anchors.append(new_anchor)
	var top_left = transform_viewport * (transform_global * edit_anchors.get(Anchors.TOP_LEFT))
	var bottom_right = transform_viewport * (transform_global * edit_anchors.get(Anchors.BOTTOM_RIGHT))
	draw_squares(top_left, bottom_right, overlay)

func draw_anchor(anchor : Dictionary, overlay : Control) -> void:
	var pos = anchor['position']
	overlay.draw_circle(pos, CIRCLE_RADIUS + STROKE_RADIUS, STROKE_COLOR)
	overlay.draw_circle(pos, CIRCLE_RADIUS, FILL_COLOR)

func draw_squares(top_left: Vector2, bottom_right: Vector2, overlay : Control) -> void:
	if grid_extents.width == 0 or grid_extents.height == 0:
		return
	var diff = bottom_right - top_left
	var p_x = (diff.x / grid_extents.size.x) * grid_extents.piece_size.x
	var p_y = (diff.y / grid_extents.size.y) * grid_extents.piece_size.y
	for y in grid_extents.height:
		for x in grid_extents.width:
			var rect = Rect2(Vector2(top_left.x + (x * p_x), top_left.y + (y * p_y)), Vector2(p_x, p_y))
			overlay.draw_rect(rect, SQUARE_COLOR[(y+x) % 2], true)

func drag_to(event_position : Vector2) -> void:
	if not dragged_anchor:
		return
	# Calculate the position of the mouse cursor relative to the RectExtents' center
	var viewport_transform_inv := grid_extents.get_viewport().get_global_canvas_transform().affine_inverse()
	var viewport_position: Vector2 = viewport_transform_inv.xform(event_position)
	var transform_inv := grid_extents.get_global_transform().affine_inverse()
	var target_position : Vector2 = transform_inv.xform(viewport_position.round())
	# Update the rectangle's size. Only resizes uniformly around the center for now
	var target_size = (target_position - grid_extents.offset).abs() * 2.0
	grid_extents.size = target_size

func forward_canvas_gui_input(event : InputEvent) -> bool:
	if not grid_extents or not grid_extents.visible:
		return false
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragged_anchor and event.is_pressed():
			for anchor in anchors:
				if not anchor['rect'].has_point(event.position):
					continue
				var undo := get_undo_redo()
				undo.create_action("Move Anchor")
				undo.add_undo_property(grid_extents, "size", grid_extents.size)
				undo.add_undo_property(grid_extents, "offset", grid_extents.offset)
				dragged_anchor = anchor
				print("Drag start: %s" % dragged_anchor)
				return true
		elif dragged_anchor and not event.is_pressed():
			print("Release drag: %s" % event.position)
			drag_to(event.position)
			dragged_anchor = {}
			var undo := get_undo_redo()
			undo.add_undo_property(grid_extents, "size", grid_extents.size)
			undo.add_undo_property(grid_extents, "offset", grid_extents.offset)
			undo.commit_action()
			return true
	if not dragged_anchor:
		return false
	if event is InputEventMouseMotion:
		drag_to(event.position)
		update_overlays()
		return true
	if event.is_action_pressed("ui_cancel"):
		dragged_anchor = {}
		var undo := get_undo_redo()
		undo.commit_action()
		undo.undo()
		return true
	return false