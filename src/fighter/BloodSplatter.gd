extends Sprite

var color: Color

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
