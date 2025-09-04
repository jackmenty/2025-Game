extends Control

func _process(float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_parent().get_node("Menu").show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true


func _on_continue_pressed() -> void:
	get_parent().get_node("Menu").hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_return_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Start_screen.tscn")


func _on_reset_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
