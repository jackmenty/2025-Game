extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CPlayer:
		body.take_damage(1)
		body.return_to_checkpoint()
