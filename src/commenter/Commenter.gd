extends Node2D

var texts = ["NICE!", "BRAVO!", "IS HE ALIVE?!", "MAKE IT RAIIIN!"]

var cur_text: int = 0
var mut = Mutex.new()

func _ready():
#	$ChangeTextTimer.start(2)
	pass
	
func next_text():
	if !$TextBox2.closed:
		return
	var text = texts[cur_text]
	
	print(text)
	cur_text = (cur_text + 1) % texts.size()
	
	$TextBox2.text = text
	$TextBox2.start()
	

func _on_ChangeTextTimer_timeout():
	next_text()


func _on_TextBox2_closed():
	pass # Replace with function body.
