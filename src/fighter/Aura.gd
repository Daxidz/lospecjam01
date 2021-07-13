extends AnimatedSprite

func _ready():
	var start_time = rand_range(0, 2)
	print(start_time)
	$Timer.start(start_time)


func _on_Timer_timeout():
	playing = true
