extends Spatial

var verts = []
var faces = []
var numx = 20
var numy = 40
var speed = 5
onready var face = $"./ImmediateGeometry"
onready var edge = $ImmediateGeometry2
onready var face2 = $ImmediateGeometry3
onready var edge2 = $ImmediateGeometry4
onready var face3 = $ImmediateGeometry5
onready var edge3 = $ImmediateGeometry6
onready var sky = $ImmediateGeometry7
onready var cam = $Camera

func draw_faces(face:ImmediateGeometry, vertices, indices):
	face.begin(Mesh.PRIMITIVE_TRIANGLES)
	var offsetY = Vector3(0, 0.01, 0)
	for i in indices:
		face.add_vertex(vertices[i[2]]-offsetY)
		face.add_vertex(vertices[i[1]]-offsetY)
		face.add_vertex(vertices[i[0]]-offsetY)
		face.add_vertex(vertices[i[0]]-offsetY)
		face.add_vertex(vertices[i[3]]-offsetY)
		face.add_vertex(vertices[i[2]]-offsetY)
	face.end()

func draw_grid(grid:ImmediateGeometry, vertices, indices):
	grid.begin(Mesh.PRIMITIVE_LINES)
	for i in indices:
		grid.add_vertex(vertices[i[0]]); grid.add_vertex(vertices[i[1]])
		grid.add_vertex(vertices[i[1]]); grid.add_vertex(vertices[i[2]])
		grid.add_vertex(vertices[i[2]]); grid.add_vertex(vertices[i[3]])
		grid.add_vertex(vertices[i[3]]); grid.add_vertex(vertices[i[0]])
	grid.end()

func draw_sky(sky:ImmediateGeometry):
	sky.begin(Mesh.PRIMITIVE_TRIANGLES)
	sky.set_uv(Vector2(0,0)); sky.add_vertex(Vector3(-60,-40,0))
	sky.set_uv(Vector2(0,1)); sky.add_vertex(Vector3(-60,40,0))
	sky.set_uv(Vector2(1,1)); sky.add_vertex(Vector3(60,40,0))
	sky.set_uv(Vector2(1,1)); sky.add_vertex(Vector3(60,40,0))
	sky.set_uv(Vector2(1,0)); sky.add_vertex(Vector3(60,-40,0))
	sky.set_uv(Vector2(0,0)); sky.add_vertex(Vector3(-60,-40,0))
	sky.end()
	
func _ready():
	randomize()
	cam.translation = Vector3(10,0.5,39)
	sky.translation = Vector3(10,-2,0)
	var y
	for i in range(0, numx):
		for j in range(0, numy):
			if i <= 4 or i >= numx-4:
				y = (cos(i*3)+abs(sin(j*3)))*rand_range(1,9)*0.15
			else: y = (cos(i*3)+sin(j*3))*rand_range(5,20)*0.01
			verts.append(Vector3(i,y,j))
	var count = 0
	for i in range(0, numy * (numx-1)):
		if count < numy - 1:
			var A = i; var B = i+1; var C = (i+numy)+1; var D = (i+numy)
			faces.append([A,B,C,D]);
			count = count + 1
		else:
			count = 0
	draw_sky(sky)
	draw_faces(face, verts, faces)
	draw_grid(edge, verts, faces)
	draw_faces(face2, verts, faces); face2.scale = Vector3(1,1,-1)
	draw_grid(edge2, verts, faces); edge2.scale = Vector3(1,1,-1)
	draw_faces(face3, verts, faces); face3.translation = Vector3(0,0,-78)
	draw_grid(edge3, verts, faces); edge3.translation = Vector3(0,0,-78)
	$Transition/AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	$Transition/AnimationPlayer.playback_speed = 0.25
	$Transition/AnimationPlayer.play("transition_in")

func on_animation_finished(anim_name):
	if anim_name == "transition_in":
		$Control.play()
		pass
	elif anim_name == "transition_out":
		pass

func _process(delta):
	if cam.translation.z >= -39:
		cam.translation = cam.translation+Vector3(0,0,-speed*delta)
		sky.translation = sky.translation+Vector3(0,0,-speed*delta)
	else:
		cam.translation = Vector3(10,0.5,39)
		sky.translation = Vector3(10,-2,0)