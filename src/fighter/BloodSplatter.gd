extends Sprite

func splater():
	$Particles2D.emitting = true
	$Particles2D.speed_scale = 1.6
	$Timer.start(0.1)

func _ready():
	splater()


func _on_Timer_timeout():
#	$Particles2D.emitting = false
	
	$Particles2D.speed_scale = 0
