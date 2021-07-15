extends Control

const MAX_PLAYER = 4
const NB_INPUT = 5


var cur_player: int = 0
var cur_input: int = 0


const focused_color: Color = Color(0x7e7185ff)
const selection_color: Color = Color(0xeae1f0ff)


var profile0 = {
	"ui_left0": KEY_A,
	"ui_right0": KEY_D,
	"ui_down0": KEY_S,
	"ui_accept0": KEY_SPACE,
	"ui_select0": KEY_V,
}

var profile1 = {
	"ui_left1": KEY_B,
	"ui_right1": KEY_BACK,
	"ui_down1": KEY_M,
	"ui_accept1": KEY_P,
	"ui_select1": KEY_7,
}

var profile2 = {
	"ui_left2": KEY_A,
	"ui_right2": KEY_D,
	"ui_down2": KEY_S,
	"ui_accept2": KEY_SPACE,
	"ui_select2": KEY_V,
}

var profile3 = {
	"ui_left3": KEY_A,
	"ui_right3": KEY_D,
	"ui_down3": KEY_S,
	"ui_accept3": KEY_SPACE,
	"ui_select3": KEY_V,
}

var players_config = [profile0, profile1, profile2, profile3]


func change_action_key(action_name, key_scancode):
	var profile = players_config[cur_player]
	for k in players_config[cur_player].keys():
		if k != action_name:
			if profile[k] == key_scancode:
				print("KEY ALREADY USED")
				return false
	erase_action_events(action_name)
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	players_config[cur_player][action_name] = key_scancode
	return true
	

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	print("Erasing:")
	print(action_name)
	for event in input_events:
		print(OS.get_scancode_string(event.scancode))
		InputMap.action_erase_event(action_name, event)


func select_profile(id: int):
	# Color setup
	var p = $VBoxContainer/PlayerSelect.get_child(id)	
	p.add_color_override("font_color", selection_color)
	cur_input = 0
	
	# Remap lines
	var profile = players_config[id]
	var i = 0
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
		$VBoxContainer/InputLines.get_child(i).update_key(profile[action_name])
		i += 1
		
	$VBoxContainer/InputLines/A.grab_focus()


func _ready():
	for p in $VBoxContainer/PlayerSelect.get_children():
		p.add_color_override("font_color", focused_color)
	select_profile(0)
	
func _process(delta):
	pass
	
func enable_line_focus(enable: bool):
	for l in $VBoxContainer/InputLines.get_children():
		l.set_focus_mode(FOCUS_ALL if enable else FOCUS_NONE)
	
	
func _input(event):
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
			
	if event.is_action_pressed("ui_accept0"):
		var l = $VBoxContainer/InputLines.get_child(cur_input)
		l.cur_color = l.selection_color
		l.update()
		
		l.get_node("Label").text = "..."
		set_process_input(false)
		enable_line_focus(false)
		
		$KeyMapper.open()
		var scancode = yield($KeyMapper, "key_selected")
		$KeyMapper.close()
		if change_action_key(players_config[cur_player].keys()[cur_input], scancode):
			l.update_key(scancode)
		else:
			l.update_key(players_config[cur_player][players_config[cur_player].keys()[cur_input]])
		
		set_process_input(true)
		enable_line_focus(true)
		l.cur_color = l.focused_color
		l.update()
			
	if p != cur_player:
		print("cur player " + str(cur_player))
		$VBoxContainer/PlayerSelect.get_child(p).add_color_override("font_color", focused_color)
		select_profile(cur_player)
		
	if i != cur_input:
		print("cur input " + str(cur_input))
		var line = $VBoxContainer/InputLines.get_child(cur_input)
		#line.grab_focus()
		line.update()
		$VBoxContainer/InputLines.get_child(i).update()

