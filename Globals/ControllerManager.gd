extends Node

var using_controller = [true, true, true, true]

var controller_connected = [false, false, false, false]

var controller_free = [true, true, true, true]


func _ready():
	for c in Input.get_connected_joypads():
		controller_connected[c] = true
	Input.connect("joy_connection_changed", self, "onJoyConChanged")


func onJoyConChanged(device: int, connected: bool):
	controller_connected[device] = connected
	controller_free[device] = connected
	
func get_free_joypad()->int:
	
	for i in controller_connected.size():
		if controller_free[i]:
			controller_free[i] = false
			return i
			
	return -1
	
	
func free_joypad(device: int):
	controller_free[device] = true
