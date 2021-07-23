extends Node

var current_scene = null
var pixel_ratio: Vector2 = Vector2(0, 0)
var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)

func goto_scene(path: String):
	next_scene = path
	call_deferred("_deferred_goto_scene", path)
	

func _deferred_goto_scene(path: String):
	
	current_scene.free()
	var s = ResourceLoader.load(next_scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
