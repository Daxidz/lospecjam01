extends Node2D

const Fighter = preload("res://src/fighter/Fighter.tscn")
#const Box = preload("res://src/world/BoxRigid.tscn")
const Box = preload("res://src/world/Box.tscn")
const Splater = preload("res://BloodSplatter.tscn")

const HitSound = preload("res://assets/sounds/hit.wav")
const MainTheme = preload("res://assets/sounds/musics/main_theme.wav")

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

export var inactive_time: float = 1.0

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
	if inactive_time != 0.0:
		$SpawnTimer.start(inactive_time)
	else:
		enable_players(true)
	nb_dead = 0
	$Camera2D.target = null
	$Camera2D.zoom_on(Vector2(1, 1))
	

func _ready():
	$Music.stream = MainTheme
	#$Music.play()
	viewport_size = get_viewport_rect().size
	start_game()
	

func _process(delta):
	for p in $Platforms.get_children():
		if p.position.y >= $StartPlatform.position.y:
			p.queue_free()

func enable_pause(enabled: bool):
	if enabled:
		get_tree().paused = true
		$Fighters.visible = false
		$Comentator.visible = false
	else:
		get_tree().paused = false
		$Fighters.visible = true
		$Comentator.visible = true

func _input(event):
	if event.is_action_pressed("ui_accept1") and not fight_running:
		start_game()
	
	if event.is_action_pressed("ui_cancel"):
		start_game()
		
	if event.is_action_pressed("ui_start0"):
		if $InputMapper.disabled:
			enable_pause(true)
			$InputMapper.open()
		else:
			enable_pause(false)
			$InputMapper.close()
			
#	if event.is_action_pressed("change_player"):
#		$Fighters.get_child(cur_fighter).control_disabled = true
#		cur_fighter = (cur_fighter +1) % $Fighters.get_child_count()
#		$Fighters.get_child(cur_fighter).control_disabled = false
		
	if event is InputEventMouseButton and event.is_pressed():
#		spawn_splatter(event.position, Color.red)
		var b = Box.instance()
		b.position = event.position
		$Boxes.add_child(b)
		pass

func fight_end(player):
	fight_running = false
	set_game_speed(0.4)
	print(player.get_path())
	$Camera2D.target = player.get_path()
	$Camera2D.zoom_on(Vector2(0.5,0.5))

func game_end():
	pass
	
	
func onPunched(player):
	$PauseTimer.start(pause_time)
#	get_tree().paused = true
	$Camera2D.decay = 0.8
	$Camera2D.add_trauma(0.6)
	$Comentator.next_text()
	$SFX.position = player.position
	$SFX.set_stream(HitSound)
	$SFX.pitch_scale = rand_range(0.8, 1.1)
	spawn_splatter(player.position, player.color, Vector2(0.2, 0.2),Vector2(0.5, 0.5))
	#$SFX.play()
	
	
func spawn_splatter(_position: Vector2, _color: Color, _scale_big: Vector2 = Vector2(1.0, 1.0), _scale_small: Vector2 = Vector2(1.0, 1.0)):
	var s = Splater.instance()
	s.position = _position
	s.color = _color
	s.position.x = clamp(s.position.x, 0, viewport_size.x)
	s.position.y = clamp(s.position.y, 0, viewport_size.y)
	s.get_node("Particles2D").scale = _scale_big
	s.get_node("SmallSplatters").scale = _scale_small
	$Splatters.add_child(s)
	
	
func onDead(player):
	spawn_splatter(player.position, player.color)
	player.queue_free()
	nb_dead+=1
	if nb_dead == nb_players-1:
		for f in $Fighters.get_children():
			if f != player:
				f.paused = true
				fight_end(f)


func _on_PauseTimer_timeout():
	get_tree().paused = false


func _on_PlatformTimer_timeout():
	enable_start_platform(false)


func _on_SpawnTimer_timeout():
	enable_players(true)
