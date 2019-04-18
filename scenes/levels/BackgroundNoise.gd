extends Sprite

onready var mat = get_material()

func _ready():
	randomize()

func _on_Timer_timeout():
	 mat.set_shader_param("offset",randf())