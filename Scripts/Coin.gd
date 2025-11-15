extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.money += 1
		queue_free()
	pass # Replace with function body.
