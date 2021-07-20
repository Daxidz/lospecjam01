extends Control

const MAX_PLAYER = 4
const NB_INPUT = 7


var cur_input: int = 0

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

var config_joypad = {
	"ui_jump": JOY_XBOX_A,
	"ui_punch": JOY_XBOX_B,
	"ui_start": JOY_START,
	"ui_left": JOY_DPAD_LEFT,
	"ui_right": JOY_DPAD_RIGHT,
	"ui_down": JOY_DPAD_DOWN,
	"ui_up": JOY_DPAD_UP,
}


func change_action_key(action_name, key_scancode, id):
	var profile = players_config[id]
	for p in players_config:
		for k in p.keys():
			if k != action_name:
				if p[k] == key_scancode:
					return false
	erase_action_events(action_name)
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	if !InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	InputMap.action_add_event(action_name, new_event)
	players_config[id][action_name] = key_scancode
	return true
	

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)



func load_all_profiles():
	for profile in players_config:
		for action_name in profile.keys():
			erase_action_events(action_name)
			var new_event = InputEventKey.new()
			new_event.set_scancode(profile[action_name])
			if !InputMap.has_action(action_name):
				InputMap.add_action(action_name)
			InputMap.action_add_event(action_name, new_event)
			
			
			
func map_joypad(joy_id: int, profile_id: int):
	
	for k in config_joypad.keys():
		var new_event = InputEventJoypadButton.new()
		new_event.device = joy_id
		new_event.set_button_index(config_joypad[k])
		if !InputMap.has_action(k+str(profile_id)):
			InputMap.add_action(k+str(profile_id))
		InputMap.action_add_event(k+str(profile_id), new_event)
		
	

func _ready():
	load_all_profiles()
	
	
	
