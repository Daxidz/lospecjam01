tool 
extends Line2D

export var displacement: float = 3

var time: float = 0.0

var point_save

var rand = RandomNumberGenerator.new()

var rand_start: float


export var freq: float = 4.0

func _ready():
	point_save = points
	time = 0.0
	rand.randomize()
	rand_start = 2*PI * randf()
	
	
func _physics_process(delta):
	time += delta
	
	var i = 0
	var nb_points: float = float(points.size())
	for p in points:
		if i != 0:
			
#			var y_p = point_save[i].y + (sin(time + (i *1.0/nb_points)) * displacement) 
			
			var disp = displacement * sin(2*PI*freq*time + (i *1.0/nb_points) +rand_start)
			var y_p = point_save[i].y + disp
			 
			
			set_point_position(i, Vector2(point_save[i].x, y_p))
	#		print(sin(time + i*1.0/nb_points))
		i+= 1
	
