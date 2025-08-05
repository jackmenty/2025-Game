extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CPlayer:
		get_tree().change_scene_to_file("res://Scenes/Sand_LVL.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
