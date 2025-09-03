extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is CPlayer:
		body.take_damage(2)
		body.return_to_checkpoint()
