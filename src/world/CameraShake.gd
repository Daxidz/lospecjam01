extends Camera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].

export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.

export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

export (NodePath) var target  # Assign the node this camera will follow.

export var zoom_time: float = 1.0


var trauma = 0.0  # Current shake strength.

var trauma_power = 2  # Trauma exponent. Use [2, 3].

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func add_trauma(amount):
	trauma = min(trauma + amount, 0.8)
	
func stop_trauma():
	trauma = 0
	
func _process(delta):
#	if target:
#		global_position = get_node(target).global_position
#	else:
#		global_position = get_viewport_rect().size/2
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	
func zoom_on(new_zoom: Vector2):
	$Tween.interpolate_property(self, "zoom", Vector2(zoom), new_zoom, zoom_time*2, Tween.TRANS_LINEAR)
	if target:
		$Tween.interpolate_property(self, "global_position", global_position, get_node(target).global_position, zoom_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property(self, "global_position", global_position, get_viewport_rect().size/2, zoom_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	$Tween.start()
