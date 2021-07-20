extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var text_size = texture.get_size() 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var time = 0
func _physics_process(delta):
#	time += delta
#
#	position += Vector2(0,1) * time * 0.1
	print(position)
	return
	if global_position.y > -text_size.y/2:
		queue_free()
