extends Node2D

var time: float = 0.0
export var amount: int = 1

var cnt: int = 0

export var displacement: float = 3

var point_save

var rand = RandomNumberGenerator.new()

var rand_start: float


export var freq: float = 4.0


func _physics_process(delta):
	
#	time += delta
#	if get_parent().velocity.length() == 0.0:
#		var i = 0
#		var nb_points: float = float($Line2D.points.size())
#		for p in $Line2D.points:
#			if i != 0:
#				var disp = displacement * sin(2*PI*freq*time + (i *1.0/nb_points) +rand_start)
#				var y_p = point_save[i].y + disp
#
#				$Line2D.set_point_position(i, Vector2(point_save[i].x, y_p))
#			i+= 1
#	else:
	$Line2D.set_point_position(0, $StaticBody2D.position)
	$Line2D.set_point_position(1, $RigidBody2D.position)
	$Line2D.set_point_position(2, $RigidBody2D2.position)


func _ready():
	
	time = 0.0
	rand.randomize()
	rand_start = 2*PI * randf()
	$Line2D.add_point($StaticBody2D.position)
	$Line2D.add_point($RigidBody2D.position)
	$Line2D.add_point($RigidBody2D2.position)
	
	point_save = $Line2D.points
