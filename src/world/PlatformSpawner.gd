extends Node2D


const Platform = preload("res://src/world/Platform.tscn")

var rand = RandomNumberGenerator.new()

export var speed: float = 100
var speed_factor: float = 1.0
export var nb_platform: int = 2

export var enabled: bool = true


func _ready():
	rand.randomize()


func spawn_platform():
	var pos: Vector2
	
	pos.x = rand.randi_range(0, get_viewport_rect().size.x)
	pos.y = 0
	
	var platform = Platform.instance()
	
	platform.speed = speed * speed_factor
	
	platform.position = pos
	
	get_parent().get_node("Platforms").add_child(platform)


func _on_Timer_timeout():
	if enabled:
		for i in nb_platform:
			spawn_platform();
