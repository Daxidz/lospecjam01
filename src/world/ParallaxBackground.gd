extends ParallaxBackground
 
 
export var camera_velocity: Vector2 = Vector2(0, 100);
var cnt = 0
 
func _process(delta: float) -> void:
	print(cnt)
	cnt += 1
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	set_scroll_offset( new_offset )
