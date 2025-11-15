extends Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


func _process(delta: float) -> void:
	mesh_instance_3d.position = Vector3.UP + Vector3.UP * cos(Time.get_ticks_msec()*0.003)*delta*20
	mesh_instance_3d.rotate(Vector3(0,1,0),1*delta)
