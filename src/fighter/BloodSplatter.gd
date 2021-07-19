extends Sprite

var color: Color

export var direction: Vector2 = Vector2(0, 0)
var time: float = 0.0
var speed: float = 1.0

func _process(delta):
	time += delta
	
	position += direction * speed * time
	
	if position.y > 150:
		queue_free()

func splater():
	material.set_shader_param("replace_col", color)
	$Particles2D.process_material.color = color
	$SmallSplatters.process_material.color = color
	$Particles2D.emitting = true
	$Particles2D.speed_scale = 1.6
	$SmallSplatters.speed_scale = 1.6
	$SmallSplatters.emitting = true
	$Timer.start(0.1)

func _ready():
	splater()


func _on_Timer_timeout():
#	$Particles2D.emitting = false
	
	$Particles2D.speed_scale = 0
	$SmallSplatters.speed_scale = 0
