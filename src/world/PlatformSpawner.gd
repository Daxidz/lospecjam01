extends Node2D


const Platform = preload("res://src/world/Platform.tscn")

var rand = RandomNumberGenerator.new()


func _ready():
	rand.randomize()


func spawn_platform():
	var pos: Vector2
	
	pos.x = rand.randi_range(0, get_viewport_rect().size.x)
	pos.y = 0
	
	var platform = Platform.instance()
	
	platform.speed = 0.68
	
	platform.position = pos
	
	get_parent().get_node("Platforms").add_child(platform)


func _on_Timer_timeout():
	for i in 2:
		spawn_platform();
