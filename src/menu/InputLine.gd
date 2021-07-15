extends HBoxContainer
tool

export var texture: Texture

var current_key

const focused_color: Color = Color(0x7e7185ff)
const selection_color: Color = Color(0xeae1f0ff)

var cur_color: Color

func _ready():
	cur_color = focused_color
	if texture != null:
		$TextureRect.texture = texture

func update_key(scancode):
	$Label.text = OS.get_scancode_string(scancode)

func draw_focus():
	var r: Rect2
	
	r.size = rect_size
	r.size.x *= 0.6
	r.size.y *= 1.1
	r.position.x += 45
	r.position.y -= 1
	draw_rect(r, cur_color, false)
	

func _draw():
	if has_focus():
		draw_focus()
		
	
