extends Node2D
tool

var velocity: Vector2
#var knockback_power: int = 50
var hit_power: int = 80

var is_punched: bool = false
export var lenght: int = 5

export var time_to_next: float = 2.0
export var texture: Texture

onready var punch_sound = load("res://assets/sounds/SFX/punch_caisse.wav")

func _ready():
	$DampedSpringJoint2D.length = lenght
	$Panneau.position.y = -lenght
	$DampedSpringJoint2D.position.y = -lenght
	$Panneau/Sprite.texture = texture
	$Panneau/Hurbox/CollisionShape2D.shape.extents = $Panneau/Sprite.texture.get_size()/2

func get_punched(enemy_pos, knockback_power):
	var punch_vec: Vector2 = position-enemy_pos
	var y_rand = rand_range(-20, -10)
	velocity = punch_vec * hit_power
	velocity.y += y_rand * punch_vec.length()
	velocity /= 6
	
	
	$Panneau.apply_central_impulse(velocity)
	$Panneau.apply_torque_impulse(0.5)
	
	
	Sounds.play_sfx_pos(punch_sound, position)
	
	if !is_punched:
		is_punched = true
		get_tree().quit()
	
	

	
func _process(delta):
	$Line2D.set_point_position(0, $StaticBody2D.position)
	$Line2D.set_point_position(1, $Panneau.position)


