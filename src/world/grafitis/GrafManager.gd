extends Node2D


var graf_per_set = [6]

const Graf = preload("res://src/world/grafitis/Graf.tscn")
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	load_random_bg()
	
func load_random_bg():
	load_bg_set(rand.randi_range(0,2))

func clear_bg():
	for g in $Grafs.get_children():
		g.queue_free()

func load_bg_set(idx: int):
	clear_bg()
	var files = get_files("res://assets/img/world/bg_" + str(idx)+"/")
	for f in files:
		var g = Graf.instance()
		g.texture = load("res://assets/img/world/bg_" + str(idx)+"/" + f)
		$Grafs.add_child(g)
	
func get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)

	var file = dir.get_next()
	while file != '':
		if file.find(".import") == -1:
			files += [file]
			print(file)
		file = dir.get_next()

	return files
