extends Node2D

var time: float = 0.0
export var amount: int = 1
export var node_lenght: int = 2

var cnt: int = 0

export var displacement: float = 3

var point_save

var rand = RandomNumberGenerator.new()

var rand_start: float



const Noeud = preload("res://src/fighter/Noeud.tscn")

var noeuds = []


func _physics_process(delta):

#	for i in amount:
	for i in $Neuds.get_child_count():
		if i == 0:
			$Line2D.set_point_position(i, $StaticBody2D.position)
		else:
			$Line2D.set_point_position(i, $Neuds.get_child(i-1).position)


func _ready():
	

	
	for i in amount:
		var n: Noeud = Noeud.instance()
		n.position.y = node_lenght * i + node_lenght # to add the first bellow the static point
		$Line2D.add_point(n.position)
		noeuds.push_back(n)
		
		$Neuds.add_child(n)
		
	for i in amount:
		var path = ""
		if i == 0:
			path = $StaticBody2D.get_path()
		else:
			path = $Neuds.get_child(i-1).get_path()
			
		$Neuds.get_child(i).get_node("Joint").node_a = path
		$Neuds.get_child(i).get_node("Joint").node_b = $Neuds.get_child(i).get_path()
		
#	for n in noeuds:
