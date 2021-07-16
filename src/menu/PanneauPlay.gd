extends Node2D

var velocity: Vector2
#var knockback_power: int = 50
var hit_power: int = 80

func get_punched(enemy_pos, knockback_power):
	var punch_vec: Vector2 = position-enemy_pos
#	punch_vec = Vector2(1/(punch_vec.x+0.1), 1/(punch_vec.y+0.1))
#	if enemy_pos.x > position.x:
#		velocity.x -= knocback_speed
#	else:
#		velocity.x = knocback_speed
	var y_rand = rand_range(-20, -10)
	velocity = punch_vec * hit_power
	velocity.y += y_rand * punch_vec.length()
	velocity /= 6
	
	
	$Panneau.apply_central_impulse(velocity)
	$Panneau.apply_torque_impulse(0.5)
	
	print("PUUUUNCH")

	
func _process(delta):
	$Line2D.set_point_position(0, $StaticBody2D.position)
	$Line2D.set_point_position(1, $Panneau.position)



