extends Node2D



const Fighter = preload("res://src/fighter/Fighter.tscn")


var lut_places = [0, 1, 2, 3]

var lut_colors = [0xf63f4cff, 0x4159cbff, 0xfdbb27ff, 0x8d902eff]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#func _input(event):

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in ControllerManager.using_controller.size():
		if ControllerManager.using_controller[i]:
			var joy_id = ControllerManager.get_free_joypad()
			if joy_id != -1:
				print("Mapping device " + str(joy_id) + " to player " + str(i))
				InputConfig.map_joypad(joy_id, i)
				
	for i in GameOptions.nb_players:
		var f = Fighter.instance()
		f.position.x = (get_viewport_rect().size.x/5) * (lut_places[i] +1)
		f.position.y = get_viewport_rect().size.y/3
		f.velocity = Vector2.ZERO
		f.controller_nb = i
		f.id = i
		f.color = Color(lut_colors[i])
		$Fighters.add_child(f)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
