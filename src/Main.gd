extends Node2D



export var pause_time: float = 0.02

var cur_fighter: int = 0

var game_speed: float = 1.0



func set_game_speed(speed: float):
#	$BG.material.set_shader_param("speed_factor", speed)
#	for f in $Fighters.get_children():
#		f.get_node("AnimationPlayer").playback_speed = speed
#	$PlatformSpawner.speed_factor = speed
	Engine.time_scale = speed
	
	
func reset_fighters():
	var pos = $Position2D.position
	for f in $Fighters.get_children():
		f.position = pos
		pos += Vector2(20, 20)
		f.velocity = Vector2.ZERO
		set_game_speed(1)	
	
	$Label.text = ""

func _ready():
	var i = 0
	for f in $Fighters.get_children():
		f.controller_nb = i
		i += 1
	set_game_speed(1)

func _process(delta):
	$FPS.text = str(Engine.get_frames_per_second())

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		reset_fighters()
			
	if event.is_action_pressed("change_player"):
		$Fighters.get_child(cur_fighter).control_disabled = true
		cur_fighter = (cur_fighter +1) % $Fighters.get_child_count()
		$Fighters.get_child(cur_fighter).control_disabled = false

func onPunched():
	$PauseTimer.start(pause_time)
#	get_tree().paused = true
	$Camera2D.decay = 0.8
	$Camera2D.add_trauma(0.6)
	
func onDead(player_nb: int):
	$Label.text = "Player " + str(player_nb) + "is dead"
#	$Camera2D.stop_trauma()
#	$Camera2D.decay = 0.9
#	$Camera2D.add_trauma(0.2)
	set_game_speed(0.4)


func _on_PauseTimer_timeout():
	get_tree().paused = false


func _on_PlatformTimer_timeout():
#	$Platform.queue_free()
	pass # Replace with function body.
