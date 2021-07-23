extends Node2D


const Box = preload("res://src/world/Box.tscn")

var texts = ["NICE!", "BRAVO!", "IS HE ALIVE?!", "MAKE IIIT\nRAIIIIIIN!", "ANOTHER ROUND\nFOR THE MAN!", "CLEAN HIT"]

var rand = RandomNumberGenerator.new()

var cur_text: int = 0
var mut = Mutex.new()
export var spawning_boxes: bool = false


func spawn_box():
	if spawning_boxes:
		var box = Box.instance()
		box.position = position + Vector2(0, -30)
		$AnimatedSprite.animation = "box_launch"
		yield(get_tree().create_timer(0.3), "timeout")
		box.velocity = Vector2(rand.randf_range(100, 300), rand.randf_range(-30, -120))
		box.get_node("Particles2D").emitting = true
		get_parent().get_node("Boxes").add_child(box)


func _ready():
	rand.randomize()
	$AnimatedSprite.playing = true
#	$ChangeTextTimer.start(2)
	pass
	
func next_text():
	if !$TextBox2.closed:
		return
	var text = texts[cur_text]
	
	$AnimatedSprite.animation = "talk"
	cur_text = (cur_text + 1) % texts.size()
	
	$TextBox2.text = text
	$TextBox2.start()
	
	
func new_text(new_text: String):
	if !$TextBox2.closed:
		return
	
	$AnimatedSprite.animation = "talk"
	var text = new_text
	
	$TextBox2.text = text
	$TextBox2.start()

func _on_ChangeTextTimer_timeout():
	next_text()


func _on_TextBox2_closed():
	$AnimatedSprite.animation = "idle"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle" or $AnimatedSprite.animation != "talk":
		$AnimatedSprite.animation = "idle"
