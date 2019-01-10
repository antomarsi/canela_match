extends Node2D

var fillers

func _ready():
	fillers = $Fills.get_children()

func _on_Map_pieces_destroyed(pieces_destroyed):
	for piece_destroyed in pieces_destroyed:
		var fill = getFillForColor(piece_destroyed.colorType)
		if fill != null:
			$ParticlesToPoint.spawn_particles(piece_destroyed.pos, fill.global_position, 1, piece_destroyed.color, fill)

func getFillForColor(colorType):
	for fill in fillers:
		if fill.colorType == colorType:
			return fill
	return null