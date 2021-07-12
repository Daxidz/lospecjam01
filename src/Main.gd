extends Node2D



export var pause_time: float = 0.02

var cur_fighter: int = 0



func _ready():
	var i = 0
	for f in $Fighters.get_children():
			f.controller_nb = i
			i += 1

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var pos = $Position2D.position
		for f in $Fighters.get_children():
			f.position = pos
			pos += Vector2(20, 20)
			f.velocity = Vector2.ZERO
			
	if event.is_action_pressed("change_player"):
		$Fighters.get_child(cur_fighter).control_disabled = true
		cur_fighter = (cur_fighter +1) % $Fighters.get_child_count()
		$Fighters.get_child(cur_fighter).control_disabled = false

func _on_Timer_timeout():
	$Platform.queue_free()
	
func onPunched():
	$PauseTimer.start(pause_time)
#	get_tree().paused = true
	$Camera2D.add_trauma(0.6)


func _on_PauseTimer_timeout():
	get_tree().paused = false
