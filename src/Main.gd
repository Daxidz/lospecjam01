extends Node2D



export var pause_time: float = 0.02



func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$Fighter.position = $Position2D.position
		$Fighter.velocity = Vector2.ZERO



func _on_Timer_timeout():
	$Platform.queue_free()
	
func onPunched():
	$PauseTimer.start(pause_time)
	get_tree().paused = true
	$Camera2D.add_trauma(0.6)


func _on_PauseTimer_timeout():
	get_tree().paused = false
