extends Control


func _on_checkpoint_pressed() -> void:
	#print("Checkpoint button pressed!")
	var player = get_tree().get_first_node_in_group("Player")
	get_tree().reload_current_scene()
	#player.global_position = player.checkpoint
	Engine.time_scale = 1
