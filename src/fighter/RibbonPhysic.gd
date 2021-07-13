extends Node2D

func _ready():
	$Line2D.add_point($StaticBody2D.position)
	$Line2D.add_point($RigidBody2D.position)
	$Line2D.add_point($RigidBody2D2.position)
	pass
	
func _process(delta):
	$Line2D.set_point_position(0, $StaticBody2D.position)
	$Line2D.set_point_position(1, $RigidBody2D.position)
	$Line2D.set_point_position(2, $RigidBody2D2.position)
#	position = get_parent().position
