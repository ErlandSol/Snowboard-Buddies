extends Node3D



func _on_area_3d_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		SignalBus.OnPlayerEnterGoalArea.emit(body)
	pass # Replace with function body.
