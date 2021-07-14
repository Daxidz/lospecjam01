extends Control

const MAX_PLAYER = 4

var cur_player: int = 0
var cur_input: int = 0

func _ready():
	pass
	
	
func load_player_config(player_id: int):
	pass
	
func _input(event):
	var p = cur_player
	if event.is_action_pressed("ui_down0"):
		pass
	if event.is_action_pressed("ui_left"):
		if cur_player == 0:
			cur_player = MAX_PLAYER -1
		else:
			cur_player = cur_player - 1
			
	if event.is_action_pressed("ui_right"):
			cur_player = (cur_player+1) % MAX_PLAYER
			
	if p != cur_player:
		load_player_config(cur_player)
