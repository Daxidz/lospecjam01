extends Node

var current_scene = null
var pixel_ratio: Vector2 = Vector2(0, 0)
var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)

func _process(delta):
	$ColorRect.material.set_shader_param("size_x", pixel_ratio.x)
	$ColorRect.material.set_shader_param("size_y", pixel_ratio.y)

func goto_scene(path: String):
	next_scene = path
	call_deferred("_deferred_goto_scene", path)
	

export var pixel_max: float = 0.008
func _deferred_goto_scene(path: String):
	
	current_scene.free()
	var s = ResourceLoader.load(next_scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
#	$FadeIn.interpolate_property(self, "pixel_ratio", Vector2(0.0, 0.0), Vector2(pixel_max, pixel_max), 0.5)
#	$FadeIn.start()
	


func _on_FadeIn_tween_all_completed():
	$FadeOut.interpolate_property(self, "pixel_ratio", Vector2(pixel_max, pixel_max), Vector2(0.0, 0.0), 0.5)
	$FadeOut.start()


func _on_FadeOut_tween_all_completed():
	current_scene.free()
	var s = ResourceLoader.load(next_scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	pass
