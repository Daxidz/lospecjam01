extends Control

const MAX_PLAYER = 4
const NB_INPUT = 7


var cur_player: int = 0
var cur_input: int = 0


const focused_color: Color = Color(0x7e7185ff)
const selection_color: Color = Color(0xeae1f0ff)

var disabled: bool = false

var profile0 = {
	"ui_jump0": KEY_SPACE,
	"ui_punch0": KEY_V,
	"ui_left0": KEY_A,
	"ui_right0": KEY_D,
	"ui_up0": KEY_W,
	"ui_down0": KEY_S,
	"ui_start0": KEY_1,
}

var profile1 = {
	"ui_jump1": KEY_UP,
	"ui_punch1": KEY_I,
	"ui_left1": KEY_LEFT,
	"ui_right1": KEY_RIGHT,
	"ui_up1": KEY_J,
	"ui_down1": KEY_DOWN,
	"ui_start1": KEY_M,
}

var profile2 = {
	"ui_jump2": KEY_KP_1,
	"ui_punch2": KEY_KP_3,
	"ui_left2": KEY_KP_4,
	"ui_right2": KEY_KP_6,
	"ui_up2": KEY_KP_8,
	"ui_down2": KEY_U,
	"ui_start2": KEY_I,
}

var profile3 = {
	"ui_jump3": KEY_5,
	"ui_punch3": KEY_6,
	"ui_left3": KEY_2,
	"ui_right3": KEY_3,
	"ui_up3": KEY_T,
	"ui_down3": KEY_Z,
	"ui_start3": KEY_4,
}

var players_config = [profile0, profile1, profile2, profile3]

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
	


func change_action_key(action_name, key_scancode):
	var profile = players_config[cur_player]
	for p in players_config:
		for k in p.keys():
			if k != action_name:
				if p[k] == key_scancode:
					$Comentator.new_text("DAAAAMN! THIS KEY IS \nALREADY ASSIGNED!")
					return false
	erase_action_events(action_name)
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	if !InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	InputMap.action_add_event(action_name, new_event)
	players_config[cur_player][action_name] = key_scancode
	return true
	

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	print(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)


func select_profile(id: int):
	# Color setup
	var p = $VBoxContainer/PlayerSelect.get_child(id)
	for p2 in $VBoxContainer/PlayerSelect.get_children():
		p2.add_color_override("font_color", focused_color)
	p.add_color_override("font_color", selection_color)
	cur_input = 0
	
	# Remap lines
	var profile = players_config[id]
	var i = 0
	for action_name in profile.keys():
#		change_action_key(action_name, profile[action_name])
		$VBoxContainer/InputLines.get_child(i).update_key(profile[action_name])
		i += 1
	for l in $VBoxContainer/InputLines.get_children():
		l.state = 0
	$VBoxContainer/InputLines.get_child(0).state = 1
	

func load_all_profiles():
	for i in MAX_PLAYER:
		cur_player = i
		var profile = players_config[i]
		for action_name in profile.keys():
			erase_action_events(action_name)
			var new_event = InputEventKey.new()
			new_event.set_scancode(profile[action_name])
			if !InputMap.has_action(action_name):
				InputMap.add_action(action_name)
			InputMap.action_add_event(action_name, new_event)
	
	cur_player = 0


func _ready():
	cur_input = 0
	load_all_profiles()
	select_profile(0)
	
	
func enable_line_focus(enable: bool):
	for l in $VBoxContainer/InputLines.get_children():
		l.set_focus_mode(FOCUS_ALL if enable else FOCUS_NONE)
	
func check_for_players_inputs(event):
	for i in 3:
		for k in players_config[i+1].keys():
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
		
		if change_action_key(players_config[cur_player].keys()[cur_input], scancode):
			l.update_key(scancode)
		else:
			l.update_key(players_config[cur_player][players_config[cur_player].keys()[cur_input]])
		
		set_process_input(true)
		l.state = 1
		l.update()
		
	if event.is_action_pressed("ui_start0"):
		SceneSwitcher.goto_scene("res://src/menu/MenuPrincipal.tscn")
	
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

