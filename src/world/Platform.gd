extends KinematicBody2D


export var speed: float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > get_viewport_rect().size.y:
		queue_free()

func _physics_process(delta):
	position.y += speed
