extends Node2D


var graf_per_set = [6]

const Graf = preload("res://src/world/grafitis/Graf.tscn")

func _ready():
	load_bg_set(0)


func load_bg_set(idx: int):
	var files = get_files("res://assets/img/world/bg_" + str(idx)+"/")
	for f in files:
		var g = Graf.instance()
		g.texture = load("res://assets/img/world/bg_" + str(idx)+"/" + f)
		add_child(g)
	
func get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)

	var file = dir.get_next()
	while file != '':
		if file.find(".import") == -1:
			files += [file]
		file = dir.get_next()

	return files
