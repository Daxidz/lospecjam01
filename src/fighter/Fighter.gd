extends KinematicBody2D

signal dead
signal punched

export var control_disabled: bool = false

# MOVEMENT 
export (int) var speed = 200
export (int) var jump_speed = -300
export (int) var gravity = 800
export (int) var knocback_speed = 200

export (Color) var color



var velocity = Vector2.ZERO

export (float, 0, 1.0) var base_friction = 0.2
var friction = base_friction
export (float, 0, 1.0) var base_acceleration = 0.15
export var coyote_time: float = 0.07

var can_jump: bool = true
var is_knockbacked: bool = false


# STATE
onready var anim_tree = get_node("AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]

func _ready():
	$Particles2D.material.set_shader_param("color", color)
	$Sprite.material.set_shader_param("color", color)
	state_machine.travel("idle")
	connect("punched", get_tree().get_root().get_node("Main"), "onPunched")
	
func get_punched(enemy_pos):
	if enemy_pos.x > position.x:
		velocity.x -= knocback_speed
	else:
		velocity.x = knocback_speed
		
	is_knockbacked = true
	friction = base_friction / 2
	$KnockbackTimer.start()
	$Particles2D.emitting = true
	
	state_machine.travel("knockback")
	emit_signal("punched")
	
	
	
func scale_x_children(new_scale: int):
	for child in get_children():
		if not child.get("scale") == null:
			child.scale.x = new_scale
	
func get_input():
		
	var cur_speed = speed
	var in_air = !is_on_floor();
	var dir = 0
	
	if !control_disabled:
		if Input.is_action_pressed("ui_right"):
			dir += 1
			scale_x_children(1)
		if Input.is_action_pressed("ui_left"):
			dir -= 1
			scale_x_children(-1)
	if dir != 0:
		if in_air:
			cur_speed *= 0.5
		velocity.x = lerp(velocity.x, dir * cur_speed, base_acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
		
		
func punch():
	state_machine.travel("attack")
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		punch()
		
		
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	
	if !is_on_floor() and $CoyoteTimer.is_stopped() and can_jump:
		$CoyoteTimer.start(coyote_time)
	elif is_on_floor():
		can_jump = true
		
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_accept"):
		if control_disabled:
			return
		if can_jump:
			velocity.y = jump_speed


func _on_CoyoteTimer_timeout():
	can_jump = false


func _on_Hitbox_area_entered(area):
	if area.get_parent() != self:
		area.get_parent().get_punched(position)


func _on_KnockbackTimer_timeout():
	is_knockbacked = false
	friction = base_friction
#	$Particles2D.emitting = false
	state_machine.travel("idle")


