extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Test_level.tscn")


func _on_reset_pressed() -> void:
	get_tree().quit()
