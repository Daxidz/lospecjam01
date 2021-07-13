extends Sprite

var texts = ["NICE!", "BRAVO!", "IS HE ALIVE?!", "MAKE IT RAIIIN!"]

var cur_text: int = 0

func _ready():
#	$ChangeTextTimer.start(2)
	pass
	
func next_text():
	$TextBox2.stop()
	var text = texts[cur_text]
	cur_text = (cur_text + 1) % texts.size()
	
	$TextBox2.text = text
	$TextBox2.rect_size.x = text.length() * 6 +2
	$TextBox2.start()

func _on_ChangeTextTimer_timeout():
	next_text()

