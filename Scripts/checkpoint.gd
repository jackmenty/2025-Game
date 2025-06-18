extends Node3D

var last_position = null
var c = false


func _on_body_entered(body: Node3D) -> void:
	if body is CPlayer:
		if c == false:
			body.death_pos = position
			body.heal_up(1)
			c = true
