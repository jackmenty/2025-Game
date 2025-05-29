extends Node


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		Player.take_damage(1)
		print(Player.health)
