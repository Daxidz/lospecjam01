extends Node2D

var MAX_PLAYERS = 4

var cur_line: int = 0



var gamemode_scenes = ["res://src/fighter/Main.tscn", "res://src/menu/MenuPrincipal.tscn"] 
var gamemode_names = ["VERSUS", "MENU"] 
var cur_gamemode: int = 0
var nb_gamemode = gamemode_scenes.size()

onready var gamemode_label = get_node("CanvasLayer/Lines/GameMode/HBoxContainer/Label")
onready var player_label = get_node("CanvasLayer/Lines/NbPlayers/HBoxContainer/Label")
onready var lifes_label = get_node("CanvasLayer/Lines/NbLifes/HBoxContainer/Label")

var nb_player: int = 4
const MAX_LIFES: int = 6
var cur_nb_life: int = 3

func update_line():
	for i in $CanvasLayer/Lines.get_child_count():
		var col = GameOptions.focused_color if i != cur_line else GameOptions.selection_color
		$CanvasLayer/Lines.get_child(i).get_node("Label").add_color_override("font_color", col)
		$CanvasLayer/Lines.get_child(i).get_node("HBoxContainer/Label").add_color_override("font_color", col)

func update_gamemode():
	gamemode_label.text = gamemode_names[cur_gamemode]
	
func update_nb_player():
	player_label.text = str(nb_player)
func update_nb_lifes():
	lifes_label.text = str(cur_nb_life)

func _ready():
	cur_nb_life = 3
	update_gamemode()
	update_nb_player()
	update_nb_lifes()
	update_line()

func _input(event):
	if event.is_action_pressed("ui_jump0"):
		GameOptions.nb_players = nb_player
		GameOptions.nb_lifes = cur_nb_life
		SceneSwitcher.goto_scene(gamemode_scenes[cur_gamemode])
		
		
	elif event.is_action_pressed("ui_right0"):
		if cur_line == 0: # nb player
			nb_player = 1 if nb_player == 4 else nb_player+1
			
		elif cur_line == 1: #gamemode
			cur_gamemode = (cur_gamemode + 1) % nb_gamemode
		elif cur_line == 2: #gamemode
			cur_nb_life = 1 if cur_nb_life == MAX_LIFES else cur_nb_life+1
	
		update_nb_player()
		update_gamemode()
		update_nb_lifes()
			
	elif event.is_action_pressed("ui_left0"):
		if cur_line == 0: # nb player
			nb_player = MAX_PLAYERS if nb_player == 1 else nb_player-1
		elif cur_line == 1: #gamemode
			cur_gamemode = nb_gamemode-1 if cur_gamemode == 0 else cur_gamemode-1
		elif cur_line == 2: #gamemode
			cur_nb_life = MAX_LIFES if cur_nb_life == 1 else cur_nb_life-1
		update_nb_player()
		update_gamemode()
		update_nb_lifes()
		
			
	elif event.is_action_pressed("ui_down0"):
		cur_line = 0 if cur_line == 2 else cur_line+1
		update_line()
		
	elif event.is_action_pressed("ui_up0"):
		cur_line = 2 if cur_line == 0 else cur_line-1
		update_line()
	
	print("Cur line: " + str(cur_line))
	print("Cur gamemode: " + str(cur_gamemode))
	print("Cur nb player: " + str(nb_player))
		
			
			
