extends Control

func _input(event):
	if event.is_action("ui_start0") or event.is_action("ui_jump0") or event.is_action("ui_punch0"):
		SceneSwitcher.goto_scene("res://src/menu/MenuPrincipal.tscn")
