extends HBoxContainer
tool

export var texture: Texture

var current_key

const focused_color: Color = Color(0x7e7185ff)
const selection_color: Color = Color(0xeae1f0ff)

var cur_color: Color

enum STATE {NONE, FOCUS, SELECTED}

var state = 0

func _ready():
	cur_color = focused_color
	if texture != null:
		$TextureRect.texture = texture

func update_key(scancode):
	$Label.text = OS.get_scancode_string(scancode)

	

func _draw():
	if state == STATE.NONE:
		cur_color = Color(0,0,0,0)
	elif state == STATE.FOCUS:
		cur_color = focused_color
	elif state == STATE.SELECTED:
		cur_color = selection_color
		
	var r: Rect2
	
	r.size = rect_size
	r.size.x *= 0.7
	r.size.y *= 1.1
	r.position.x += 37
	r.position.y -= 1
	draw_rect(r, cur_color, false)
		
	
