extends KinematicBody2D

signal dead
signal punched

export var control_disabled: bool = false

# MOVEMENT 
export (int) var speed = 180
export (int) var jump_speed = -400
export (int) var gravity = 1100
var cur_gravity: int = gravity
export (int) var knocback_speed = 50

export (Color) var color

export var ko_margin: float = 10.0

var velocity = Vector2.ZERO

var speed_factor

export (float, 0, 1.0) var base_friction = 0.2
var friction = base_friction
export (float, 0, 1.0) var base_acceleration = 0.15
export var coyote_time: float = 0.07

var can_jump: bool = true
var is_knockbacked: bool = false

var controller_nb: int = -1 # assigned to a controller


# STATE
onready var anim_tree = get_node("AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]

func _ready():
	$Hitbox/CollisionShape2D.disabled = true
	$Particles2D.material.set_shader_param("color", color)
	$Sprite.material.set_shader_param("color", color)
	#$Sprite2.material.set_shader_param("replace_col", color)
	state_machine.travel("idle")
	connect("punched", get_tree().get_root().get_node("Main"), "onPunched")
	connect("dead", get_tree().get_root().get_node("Main"), "onDead")
	
func get_punched(enemy_pos):
	var punch_vec = position-enemy_pos
#	punch_vec = Vector2(1/(punch_vec.x+0.1), 1/(punch_vec.y+0.1))
#	if enemy_pos.x > position.x:
#		velocity.x -= knocback_speed
#	else:
#		velocity.x = knocback_speed
	velocity = punch_vec * knocback_speed
#
	is_knockbacked = true
	friction = base_friction / 2
	$KnockbackTimer.start()
	$Particles2D.emitting = true
	
	cur_gravity = gravity/2
	
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
	
	if !control_disabled && !is_knockbacked:
		if Input.is_action_pressed("ui_right"+str(controller_nb)):
			dir += 1
			scale_x_children(1)
		if Input.is_action_pressed("ui_left"+str(controller_nb)):
			dir -= 1
			scale_x_children(-1)
	if dir != 0:
		if in_air:
			cur_speed *= 0.5
		if is_knockbacked:
			cur_speed *= 0.1
		velocity.x = lerp(velocity.x, dir * cur_speed, base_acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
		
		
func punch():
	state_machine.travel("attack")
	
func _input(event):
	if event.is_action_pressed("ui_select"+str(controller_nb)):
		if (!control_disabled):
			punch()

func _process(delta):
	if position.x > get_viewport_rect().size.x + ko_margin or position.y > get_viewport_rect().size.y +ko_margin or position.x < -ko_margin:
		emit_signal("dead", controller_nb)
		
func _physics_process(delta):
	get_input()
	velocity.y += cur_gravity * delta
	
	if !is_on_floor() and $CoyoteTimer.is_stopped() and can_jump:
		$CoyoteTimer.start(coyote_time)
	elif is_on_floor():
		can_jump = true
		
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_accept"+str(controller_nb)):
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
	cur_gravity = gravity


