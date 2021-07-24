extends Node2D

var com_texts = ["WELCOME TO THE\nCAT CLUB!", "SMASH ONE OF\nTHESE, WOULD YA!", "YOU CAN REMAP\nTHE INPUTS VIA\nINPUTS MENU", "LONG REACH FTW!", "PRAISE THAT SUN!", "OH, AND DONT TALK\nABOUT THE CAT CLUB"]
var cur_text = 0

var boxes_texts = ["BOXES HIT HARD\nAS HELL MAN!", "TOLD YA!", "TRY PUNCHIN IT!"]
var cur_box_text = 0

func _ready():
	var joy_id = ControllerManager.get_free_joypad()
	if joy_id != -1:
		InputConfig.map_joypad(joy_id, 0)
	$ComTimer.start(2)


func _on_ComTimer_timeout():
	if $Comentator.new_text(com_texts[cur_text]):
		cur_text = (cur_text + 1) % com_texts.size()
	$ComTimer.start(8)


func _on_Fighter_punched(player):
	if $Comentator.new_text(boxes_texts[cur_box_text]):
		cur_box_text = (cur_box_text + 1) % boxes_texts.size()
