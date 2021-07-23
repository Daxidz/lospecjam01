extends Control

tool

const LifeCounter = preload("res://src/menu/LifeCounter.tscn")


export var nb_life: int = 3
var cur_life: int = nb_life
export var color: Color


# Called when the node enters the scene tree for the first time.
func _ready():
	cur_life = nb_life
	for i in nb_life:
		add_life_icon()
	
func load_full_life():
	cur_life = nb_life
	for i in nb_life - cur_life:
		add_life_icon()
		
		


func lose_life():
	if cur_life == 0:
		return
	cur_life -= 1
	$HBoxContainer.get_child(0).queue_free()
	
	
func add_life_icon():
	var l = LifeCounter.instance()
	l.texture = load("res://assets/img/fighter/life.png")
	l.material.set_shader_param("color", color)
	$HBoxContainer.add_child(l)



func _on_Tween_tween_all_completed():
	pass # Replace with function body.
