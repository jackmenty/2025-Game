extends Control


func _on_checkpoint_pressed() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
