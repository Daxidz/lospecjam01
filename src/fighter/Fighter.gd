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
export (int) var hit_power = 50

export (Color) var color

export var ko_margin: float = 10.0

var velocity = Vector2.ZERO

var speed_factor

export (float, 0, 1.0) var base_friction = 0.2
export (float, 0, 1.0) var knockback_friction = 0.1
var friction = base_friction
export (float, 0, 1.0) var base_acceleration = 0.15
export var coyote_time: float = 0.07

export var knockback_time: float = 0.5

var can_jump: bool = true
var can_rotate: bool = true
var is_knockbacked: bool = false

var controller_nb: int = -1 # assigned to a controller


# STATE
onready var anim_tree = get_node("AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]

func _ready():
	$Hitbox/CollisionShape2D.disabled = true
	$Particles2D.material.set_shader_param("color", color)
	$Sprite.material.set_shader_param("color", color)
	$Bandana.default_color = color
	$RibbonPhysic/Line2D.default_color = color
	state_machine.travel("idle")
	connect("punched", get_tree().get_root().get_node("Main"), "onPunched")
	connect("dead", get_tree().get_root().get_node("Main"), "onDead")
	
func get_punched(enemy_pos, knockback_power):
	var punch_vec: Vector2 = position-enemy_pos
	var y_rand = rand_range(-20, -10)
	velocity = punch_vec * knockback_power
	velocity.y += y_rand * punch_vec.length()
#
	is_knockbacked = true
	$KnockbackTimer.start(knockback_time)
	$Particles2D.emitting = true
	$Particles2D.scale + 0.5 * punch_vec.normalized()
	
	state_machine.travel("knockback")
	emit_signal("punched", self)
	
	
	
func scale_x_children(new_scale: int):
	for child in get_children():
		if not child.get("scale") == null:
			child.scale.x = new_scale
	
	$RibbonPhysic.position.x = -1 if new_scale == 1 else 1
	
func get_input():
		
	var cur_speed = speed
	var in_air = !is_on_floor();
	var dir = 0
	
	can_rotate = $AnimationPlayer.current_animation != "attack" and $JumpDirTimer.is_stopped()
	
	friction = base_friction
	
	if !control_disabled && !is_knockbacked:
		if Input.is_action_pressed("ui_right"+str(controller_nb)):
			dir += 1
			if can_rotate:
				scale_x_children(1)
		if Input.is_action_pressed("ui_left"+str(controller_nb)):
			dir -= 1
			if can_rotate:
				scale_x_children(-1)
	if dir != 0:
		if in_air:
			cur_speed *= 0.5
		if is_knockbacked:
			cur_speed *= 0.1
		velocity.x = lerp(velocity.x, dir * cur_speed, base_acceleration)
	else:
		if is_knockbacked:
			friction = knockback_friction
		velocity.x = lerp(velocity.x, 0, friction)
		
		
		
func punch():
	state_machine.travel("attack")
	
func _input(event):
	if event.is_action_pressed("ui_select"+str(controller_nb)):
		if (!control_disabled):
			punch()

func _process(delta):
	if position.x > get_viewport_rect().size.x + ko_margin or position.y > get_viewport_rect().size.y +ko_margin or position.x < -ko_margin:
		emit_signal("dead", self)
	
	if is_on_floor():
		if abs(velocity.x) >0.2:
			
			print("running")
			state_machine.travel("run")
		else:
			print("idling")
			state_machine.travel("idle")
		
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
			can_rotate = false
			$JumpDirTimer.start()
			velocity.y = jump_speed


func _on_CoyoteTimer_timeout():
	can_jump = false


func _on_Hitbox_area_entered(area):
	if area.get_parent() != self:
		area.get_parent().get_punched(position, hit_power)


func _on_KnockbackTimer_timeout():
	is_knockbacked = false
	friction = base_friction
	$Particles2D.emitting = false
	state_machine.travel("idle")


func _on_JumpDirTimer_timeout():
	can_rotate = true
