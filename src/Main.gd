extends Node2D

const Fighter = preload("res://src/fighter/Fighter.tscn")
#const Box = preload("res://src/world/BoxRigid.tscn")
const Box = preload("res://src/world/Box.tscn")
const Splater = preload("res://BloodSplatter.tscn")
const LifesBar = preload("res://src/menu/Lifes.tscn")

const MainTheme = preload("res://assets/sounds/musics/main_theme0.wav")
const exposion_sound = preload("res://assets/sounds/SFX/explosion.wav")
onready var spawn_sound = load("res://assets/sounds/SFX/spawn.wav")
onready var start_sound = load("res://assets/sounds/SFX/start_fight.wav")

export var pause_time: float = 0.02

var cur_fighter: int = 0

var game_speed: float = 1.0

var game_running: bool

var fight_running: bool

var lut_places = [0, 1, 2, 3]

var lut_colors = [0xf63f4cff, 0x4159cbff, 0xfdbb27ff, 0x8d902eff]

export var nb_players: int = 4
export var nb_lifes: int = 6
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
	for l in $LifesHBox.get_children():
		l.queue_free()
		
	var tot_pos = get_viewport_rect().size
	for i in nb_players:
		var f = Fighter.instance()
		f.position.x = (tot_pos.x/5) * (lut_places[i] +1)
		f.position.y = tot_pos.y/3
		f.velocity = Vector2.ZERO
		f.controller_nb = i
		f.id = i
		f.color = Color(lut_colors[i])
		f.control_disabled = true
		$Fighters.add_child(f)
		
		#Spawn life bars
		var l = LifesBar.instance()
		l.nb_life = GameOptions.nb_lifes
		l.get_node("HBoxContainer").alignment = 1
		l.color = Color(lut_colors[i])
		$LifesHBox.add_child(l)
		players_life[i] = GameOptions.nb_lifes

		
		
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
	paused = false
	enable_start_platform(true)
	
		
	set_game_speed(1)
		
	nb_players = GameOptions.nb_players
	reset_fighters()
	enable_players(false)
	delete_boxes()
	delete_splaters()
	enable_pause(false)
	Sounds.play_sfx_pos(spawn_sound, position)
	
	nb_dead = 0
	
	camera.target = null
	camera.zoom_on(Vector2(1, 1))
	
	yield(get_tree().create_timer(0.2), "timeout")
	enable_players(true)
	
	$BG2.load_random_bg()
	
	$PauseMenu/Control.visible = false
	

func _ready():
	for i in ControllerManager.using_controller.size():
		if ControllerManager.using_controller[i]:
			var joy_id = ControllerManager.get_free_joypad()
			if joy_id != -1:
				print("Mapping device " + str(joy_id) + " to player " + str(i))
				InputConfig.map_joypad(joy_id, i)
	music.stream = MainTheme
	music.play()
	viewport_size = get_viewport_rect().size
	start_game()
	

func _process(delta):
	for p in $Platforms.get_children():
		if p.position.y >= $StartPlatform.position.y:
			p.queue_free()

func enable_pause(enabled: bool):
	if enabled:
		get_tree().paused = true
		$Comentator.visible = false
		paused = true
		$PauseMenu/Control.visible = true
		music.volume_db = -8
	else:
		music.volume_db = 0
		$PauseMenu/Control.visible = false
		paused = false
		get_tree().paused = false
		$Comentator.visible = true

func show_pause_menu():
	$PauseMenu/Control.visible = true
	
var paused: bool = false

func _input(event):
	if event.is_action_pressed("ui_jump0") and (not fight_running or paused):
		start_game()
	
	if event.is_action_pressed("ui_punch0") and (not fight_running or paused):
		set_game_speed(1.0)
		enable_pause(false)
		SceneSwitcher.goto_scene("res://src/menu/MenuPrincipal.tscn")
		
	
	if event.is_action_pressed("ui_start0") and fight_running and paused:
		enable_pause(false)
	elif event.is_action_pressed("ui_start0") and fight_running and not paused:
		enable_pause(true)
		
		
	if event is InputEventMouseButton and event.is_pressed():
#		spawn_splatter(event.position, Color.red)
		var b = Box.instance()
		b.position = event.position
		$Boxes.add_child(b)

func fight_end(player):
	fight_running = false
	set_game_speed(0.4)
	print(player.get_path())
	camera.target = player.get_path()
	camera.zoom_on(Vector2(0.5,0.5))
	$PauseMenu/Control.visible = true

func game_end():
	pass
	

onready var camera = get_node("Node2D/Camera2D")
onready var sfx = Sounds.get_node("SFX")
onready var music = Sounds.get_node("Music")

func onPunched(player):
	$PauseTimer.start(pause_time)
#	get_tree().paused = true
	camera.decay = 0.8
	camera.add_trauma(0.5)
	$Comentator.next_text()
	spawn_splatter(player.position, player.color, Vector2(0.1, 0.1),Vector2(0.4, 0.4), true)

	
	
func spawn_splatter(_position: Vector2, _color: Color, _scale_big: Vector2 = Vector2(1.0, 1.0), _scale_small: Vector2 = Vector2(1.0, 1.0), enabled: bool = false):
	var s = Splater.instance()
	s.position = _position
	s.color = _color
	s.position.x = clamp(s.position.x, 0, viewport_size.x)
	s.position.y = clamp(s.position.y, 0, viewport_size.y)
	s.get_node("Particles2D").scale = _scale_big
	s.get_node("SmallSplatters").scale = _scale_small
	if enabled:
		s.direction = Vector2(0,1)
		s.speed = 0.2
	$Splatters.add_child(s)
	
var players_life = [nb_lifes, nb_lifes, nb_lifes, nb_lifes]
	
func onDead(player):
	$LifesHBox.get_child(player.id).lose_life()
	players_life[player.id] -= 1
	if players_life[player.id] == 0:
		spawn_splatter(player.position, player.color)
		Sounds.play_sfx_pos(exposion_sound, player.position, -8, 0.9)
		camera.add_trauma(0.6)
		player.queue_free()
		nb_dead+=1
		$Comentator.new_text("CAT DOWN!")
		if nb_dead == nb_players-1:
			for f in $Fighters.get_children():
				if f != player:
					f.paused = true
					fight_end(f)
	elif players_life[player.id] < 0:
		return
	else: 
		player.visible = false
		var tot_pos = get_viewport_rect().size
		spawn_splatter(player.position, player.color, Vector2(0.6, 0.6))
		camera.add_trauma(0.4)
		player.position.x = (tot_pos.x/5) * (lut_places[player.id] +1)
		player.position.y = tot_pos.y/3
		player.velocity = Vector2.ZERO
		player.visible = true
		player.make_invicible()
		
		


func _on_PauseTimer_timeout():
	get_tree().paused = false


func _on_PlatformTimer_timeout():
	enable_start_platform(false)


func _on_SpawnTimer_timeout():
	enable_players(true)
