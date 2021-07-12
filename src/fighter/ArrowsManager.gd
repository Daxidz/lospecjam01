extends Node2D


const Arrow = preload("res://src/world/Arrow.tscn")
onready var viewport_size = get_viewport_rect().size

var margin: int = 5

var nb_players: int = 4



func _ready():
	for f in nb_players:
		var arrow = Arrow.instance()
		add_child(arrow)

func _process(delta):
	var i = 0
	var a_visible = false
	var a_position: Vector2
	var a_rot: int
		
	for f in get_parent().get_node("Fighters").get_children():
		a_visible = false
		if f.position.x > viewport_size.x:
			a_visible = true
			a_rot = -90
			a_position.x = viewport_size.x - margin
			a_position.y = f.position.y
		elif f.position.x < 0:
			a_visible = true
			a_rot = 90
			a_position.x = margin
			a_position.y = f.position.y
		elif f.position.y < 0:
			a_visible = true
			a_rot = 180
			a_position.x = f.position.x
			a_position.y = margin
			
		var arrow = get_child(i)
		arrow.visible = a_visible
		
		i += 1
		
		if a_visible:
			arrow.rotation_degrees = a_rot
			a_position.x = clamp(a_position.x, margin, viewport_size.x-margin)
			a_position.y = clamp(a_position.y, margin, viewport_size.y-margin)
			
			arrow.position = a_position
			arrow.material.set_shader_param("color", f.color)

	for j in nb_players-i:
		var arrow = get_child((nb_players-1)-j)
		arrow.visible = a_visible
