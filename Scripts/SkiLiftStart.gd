@tool
extends Node3D
class_name SkiLiftStart
@onready var line: Node3D = $Line

@export var end : SkiLiftEnd
#@onready var anchor: Node3D = $Anchor
@export var anchor: MeshInstance3D

@export_tool_button("Update")
var button: Callable = func():
	stretch_quad_between_points()		

func _ready() -> void:
	#if end != null:
		#stretch_quad_between_points()
	pass





func stretch_quad_between_points():

	var start = anchor.global_position
	var endpos = end.anchor.global_position
	
	var dir = endpos - start
	
	var length = dir.length()
	if length == 0:
		return
	
	dir = dir.normalized()
	
	line.rotation = Vector3.ZERO
	line.look_at(endpos)
	
	line.scale.x = 1
	line.scale.y = 1
	
	line.scale.z = length
	
	line.position = anchor.position + (dir * length * .5)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerAgent:
		body.position = end.position
		body.rotation = end.rotation
		body.velocity = Vector3.ZERO
		#body.currentLap += 1
		if not body.NPC:
			body.cameraController.teleportToTarget()
		
	pass # Replace with function body.
