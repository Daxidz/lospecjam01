extends Node2D

const Fighter = preload("res://src/fighter/Fighter.tscn")
const Box = preload("res://src/world/BoxRigid.tscn")
const Splater = preload("res://BloodSplatter.tscn")

const HitSound = preload("res://assets/sounds/hit.wav")

export var pause_time: float = 0.02

var cur_fighter: int = 0

var game_speed: float = 1.0

var game_running: bool

var fight_running: bool

var lut_places = [0, 3, 1, 2]

var lut_colors = [0xf63f4cff, 0x4159cbff, 0xfdbb27ff, 0x8d902eff]

export var nb_players: int = 4
var nb_dead: int = 0

export var use_platform: bool

var viewport_size: Vector2


func set_game_speed(speed: float):
#	$BG.material.set_shader_param("speed_factor", speed)
#	for f in $Fighters.get_children():
#		f.get_node("AnimationPlayer").playback_speed = speed
#	$PlatformSpawner.speed_factor = speed
	Engine.time_scale = speed
	
	
func enable_players(enable : bool):
	for f in $Fighters.get_children():
		f.control_disabled = not enable
	
func reset_fighters():
	for f in $Fighters.get_children():
		f.free()
		
	var tot_pos = get_viewport_rect().size
	for i in nb_players:
		var f = Fighter.instance()
		f.position.x = (tot_pos.x/5) * (lut_places[i] +1)
		f.position.y = tot_pos.y/3
		f.velocity = Vector2.ZERO
		f.controller_nb = i
		f.color = Color(lut_colors[i])
		$Fighters.add_child(f)
		
		
func delete_boxes():
	for b in $Boxes.get_children():
		b.queue_free()
	
func delete_splaters():
	for s in $Splatters.get_children():
		s.queue_free()
	
func enable_start_platform(enable: bool):
	$StartPlatform.visible = enable
	$StartPlatform/CollisionShape2D.disabled = not enable

func start_game():
	for p in $Platforms.get_children():
		p.queue_free()
	game_running = true
	fight_running = true
	enable_start_platform(true)
	
	if use_platform:
		$PlatformTimer.start(5)
		
	set_game_speed(1)
	
	reset_fighters()
	enable_players(false)
	delete_boxes()
	delete_splaters()
	$SpawnTimer.start(1)
	nb_dead = 0
	

func _ready():
	viewport_size = get_viewport_rect().size
	start_game()
	

func _process(delta):
	$FPS.text = str(Engine.get_frames_per_second())

func _input(event):
	if event.is_action_pressed("ui_accept1") and not fight_running:
		start_game()
	
	if event.is_action_pressed("ui_cancel"):
		start_game()
			
	if event.is_action_pressed("change_player"):
		$Fighters.get_child(cur_fighter).control_disabled = true
		cur_fighter = (cur_fighter +1) % $Fighters.get_child_count()
		$Fighters.get_child(cur_fighter).control_disabled = false
		
	if event is InputEventMouseButton and event.is_pressed():
		spawn_splatter(event.position, Color.red)
#		var b = Box.instance()
#		b.position = event.position
#		$Boxes.add_child(b)

func fight_end():
	fight_running = false
	set_game_speed(0.4)

func game_end():
	pass
	
	
func onPunched(player):
	$PauseTimer.start(pause_time)
#	get_tree().paused = true
	$Camera2D.decay = 0.8
	$Camera2D.add_trauma(0.6)
	$Commenter.next_text()
	$SFX.position = player.position
	$SFX.set_stream(HitSound)
	$SFX.pitch_scale = rand_range(0.8, 1.1)
	$SFX.play()
	
	
func spawn_splatter(position: Vector2, color: Color):
	var s = Splater.instance()
	s.get_node("Particles2D").material.set_shader_param("replace_col", color)
	s.position = position
	s.position.x = clamp(s.position.x, 0, viewport_size.x)
	s.position.y = clamp(s.position.y, 0, viewport_size.y)
	$Splatters.add_child(s)
	
	
func onDead(player):
	spawn_splatter(player.position, player.color)
	player.queue_free()
	nb_dead+=1
	if nb_dead == nb_players-1:
		fight_end()


func _on_PauseTimer_timeout():
	get_tree().paused = false


func _on_PlatformTimer_timeout():
	enable_start_platform(false)


func _on_SpawnTimer_timeout():
	enable_players(true)
