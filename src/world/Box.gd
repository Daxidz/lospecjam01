extends KinematicBody2D


var gravity: int = 500

var velocity: Vector2
var hit_power: int = 60

var friction: float = 0.1

func get_punched(enemy_pos, knockback_power):
	var punch_vec = position-enemy_pos
#	punch_vec = Vector2(1/(punch_vec.x+0.1), 1/(punch_vec.y+0.1))
#	if enemy_pos.x > position.x:
#		velocity.x -= knocback_speed
#	else:
#		velocity.x = knocback_speed
	var y_rand = rand_range(-10, -5)
	velocity = punch_vec * knockback_power *0.3
	
	velocity.y += y_rand * punch_vec.length()*0.8
	
	$Particles2D.emitting = true


func _physics_process(delta):
	velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, friction)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
	
func _on_Hitbox_area_entered(area):
	if area.get_parent() != self:
		area.get_parent().get_punched(position, hit_power)
