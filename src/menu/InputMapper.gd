
extends Control

const MAX_PLAYER = 4
const NB_INPUT = 7


var cur_player: int = 0
var cur_input: int = 0


const focused_color: Color = Color(0x7e7185ff)
const selection_color: Color = Color(0xeae1f0ff)

var disabled: bool = true




func open():
	
	cur_input = 0
	cur_player = 0
	visible = true
	disabled = false
	select_profile(0)
	
	
func close():
	visible = false
	disabled = true
	
	get_tree().paused = false
	


func select_profile(id: int):
	# Color setup
	var p = $VBoxContainer/PlayerSelect.get_child(id)
	for p2 in $VBoxContainer/PlayerSelect.get_children():
		p2.add_color_override("font_color", focused_color)
	p.add_color_override("font_color", selection_color)
	cur_input = 0
	
	# Remap lines
	var profile = InputConfig.players_config[id]
	var i = 0
	for action_name in profile.keys():
#		change_action_key(action_name, profile[action_name])
		$VBoxContainer/InputLines.get_child(i).update_key(profile[action_name])
		i += 1
	for l in $VBoxContainer/InputLines.get_children():
		l.state = 0
	$VBoxContainer/InputLines.get_child(0).state = 1
	update_using_controller()
	
	
func update_using_controller():
	var color_joypad_text: Color
	if ControllerManager.using_controller[cur_player]:
		color_joypad_text = selection_color
	else:
		color_joypad_text = focused_color
	
	$HBoxContainer/Label.add_color_override("font_color", color_joypad_text)


func _ready():
	cur_input = 0
	cur_player = 0
	open()
	
	
func enable_line_focus(enable: bool):
	for l in $VBoxContainer/InputLines.get_children():
		l.set_focus_mode(FOCUS_ALL if enable else FOCUS_NONE)
	
func check_for_players_inputs(event):
	for i in 3:
		for k in InputConfig.players_config[i+1].keys():
			if event.is_action_pressed(k):
				$Comentator.new_text("STAY CALM PLEASE!\nONLY P1 CAN CHANGE\nSETTINGS!")
			
	
func _input(event):
	if disabled:
		return
	var p = cur_player
	var i = cur_input
	if event.is_action_pressed("ui_down0"):
		if cur_input != NB_INPUT-1:
			cur_input += 1
		print("cur input " + str(cur_input))
	if event.is_action_pressed("ui_up0"):
		if cur_input != 0:
			cur_input = cur_input - 1
	if event.is_action_pressed("ui_left0"):
		if cur_player > 0:
			cur_player = cur_player - 1
	if event.is_action_pressed("ui_right0"):
		if cur_player < MAX_PLAYER -1:
			cur_player += 1
	check_for_players_inputs(event)
			
	if event.is_action_pressed("ui_jump0"):
		var l = $VBoxContainer/InputLines.get_child(cur_input)
		l.state = 2
		l.update()
		
		l.get_node("Label").text = "..."
		set_process_input(false)
		
		get_parent().set_process_input(false)
		$KeyMapper.open()
		var scancode = yield($KeyMapper, "key_selected")
		$KeyMapper.close()
		get_parent().set_process_input(true)
		
		if InputConfig.change_action_key(InputConfig.players_config[cur_player].keys()[cur_input], scancode, cur_player):
			l.update_key(scancode)
		else:
			l.update_key(InputConfig.players_config[cur_player][InputConfig.players_config[cur_player].keys()[cur_input]])
			$Comentator.new_text("DAAAAMN! THIS KEY IS \nALREADY ASSIGNED!")
		
		set_process_input(true)
		l.state = 1
		l.update()
		
	if event.is_action_pressed("ui_start0"):
		SceneSwitcher.goto_scene("res://src/menu/MenuPrincipal.tscn")
		
	if event.is_action_pressed("ui_punch0"):
		ControllerManager.using_controller[cur_player] = !ControllerManager.using_controller[cur_player]
		update_using_controller()
		var nb_connected = 0
		var using_controller = 0
		for j in 4:
			if ControllerManager.using_controller[j]:
				using_controller += 1
			if ControllerManager.controller_connected[j]:
				nb_connected += 1
		if using_controller > nb_connected:
			$Comentator.new_text("YOU DONT HAVE ENOUGH\nJOYPADS CONNECTED!\nCONNECT ANOTHER!")
			
	
	if p != cur_player:
		print("cur player " + str(cur_player))
		$VBoxContainer/PlayerSelect.get_child(p).add_color_override("font_color", focused_color)
		select_profile(cur_player)
		
	if i != cur_input:
		print("cur input " + str(cur_input))
		var line = $VBoxContainer/InputLines.get_child(cur_input)
		line.state = 1
		line.update()
		var old_line = $VBoxContainer/InputLines.get_child(i)
		old_line.state = 0
		old_line.update()



