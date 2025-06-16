extends Control

func _process(float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_parent().get_node("Menu").show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Engine.time_scale = 0


func _on_continue_pressed() -> void:
	get_parent().get_node("Menu").hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.time_scale = 1


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start_screen.tscn")
	Engine.time_scale = 1
