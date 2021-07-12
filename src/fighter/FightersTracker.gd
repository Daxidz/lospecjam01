extends Node2D


const Arrow = preload("res://src/world/Arrow.tscn")
onready var viewport_size = get_viewport_rect().size

var margin: int = 5



func _ready():
	for f in get_children():
		var arrow = Arrow.instance()
#		arrow.material.set_shader_param("color", f.color)
		get_parent().get_node("OffScreenArrows").add_child(arrow)

func _process(delta):
	var i = 0
	var a_visible = false
	var a_position: Vector2
	var a_rot: int
	for f in get_children():
		a_visible = false
		var arrow = get_parent().get_node("OffScreenArrows").get_child(i)
		i += 1
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
			
		arrow.visible = a_visible
		if a_visible:
			arrow.rotation_degrees = a_rot
			a_position.x = clamp(a_position.x, margin, viewport_size.x-margin)
			a_position.y = clamp(a_position.y, margin, viewport_size.y-margin)
			
			arrow.position = a_position
			
			print(a_position)
			arrow.material.set_shader_param("color", f.color)
			
