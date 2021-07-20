extends HBoxContainer

tool

const LifeCounter = preload("res://src/menu/LifeCounter.tscn")


export var nb_life: int = 3
var cur_life: int = nb_life
export var color: Color


# Called when the node enters the scene tree for the first time.
func _ready():
	cur_life = nb_life
	for i in nb_life:
		var l = LifeCounter.instance()
		l.texture = load("res://assets/img/fighter/life.png")
		l.material.set_shader_param("color", color)
		add_child(l)
	
func load_full_life():
	cur_life = nb_life
	for i in nb_life - cur_life:
		var l = TextureRect.new()
		l.texture = load("res://assets/img/fighter/life.png")
		add_child(l)
		
		


func lose_life():
	if cur_life == 0:
		return
	cur_life -= 1
	get_child(0).queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
