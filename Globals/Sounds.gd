extends Node



func play_sfx_pos(sfx: Resource, position: Vector2, volume_db: float = 0.0, pitch: float = 1.0):
	print("SFX playing : " + str(sfx))
	$SFX.stream = sfx
#	$SFX.position = position
	$SFX.volume_db = volume_db
	$SFX.pitch_scale = pitch
	$SFX.play()

func play_music(path: Resource):
	$Music.stream = path
	$Music.play()
