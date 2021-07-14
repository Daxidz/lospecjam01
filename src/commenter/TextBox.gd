extends Node2D

signal closed()



onready var label = get_node("TextBox2/MarginContainer/Label")
onready var timer = get_node("Timer")
onready var ninerect = get_node("TextBox2/NinePatchRect")

var step = 0.0
var nb_visible = 0
var text_lenght = 0

export var text_speed = 0.1

export var text = ""
var closed: bool = true

var autostop: bool = true

func _ready():
	$TextBox2.rect_size = Vector2.ZERO
	label.percent_visible = 1
	modulate = Color(1,1,1,0)

func _on_Timer_timeout():
	if nb_visible < text_lenght:
		label.text += text[nb_visible]
		timer.start(text_speed)
	else:
		if autostop:
			$EndTimer.start(1)

	nb_visible += 1
	
func start():
	closed = false
	
	
	text_lenght = text.length()
	
	$TextBox2.rect_size.x = text.length() * 6 + 5
	$TextBox2.rect_size.y = 10
	$TextBox2.rect_position = Vector2.ZERO
	modulate = Color(1,1,1,1)
	
	if text_lenght == 0:
		return
	step = 1.0 / text_lenght
	
	timer.start(text_speed)
	
func stop():
	label.text = ""
	nb_visible = 0
	$Tween.interpolate_property($TextBox2, "rect_size", $TextBox2.rect_size, Vector2(0, $TextBox2.rect_size.y), 0.5, Tween.TRANS_BOUNCE)
#	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_SINE)
	$Tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("closed")
	closed = true


func _on_EndTimer_timeout():
	stop()
