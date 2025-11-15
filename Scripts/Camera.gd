extends Camera3D

@onready var camera_hinge: Node3D = $".."
@export var board: CharacterBody3D

var hinge: Node3D
var player: Player

var rotationSpeed := 2.0
var moveSpeed := 10.0

func _physics_process(delta: float) -> void:
	if (board == null): return
	camera_hinge.position = camera_hinge.position.lerp(board.position,delta*moveSpeed)
	camera_hinge.rotation.x = lerp_angle( camera_hinge.rotation.x, board.global_rotation.x, delta*rotationSpeed )
	camera_hinge.rotation.y = lerp_angle( camera_hinge.rotation.y, board.global_rotation.y, delta*rotationSpeed )
	camera_hinge.rotation.z = lerp_angle( camera_hinge.rotation.z, board.global_rotation.z, delta*rotationSpeed )
	pass
	
func teleportToPlayer():
	if (board == null): return
	camera_hinge.position = board.position
	camera_hinge.rotation = board.global_rotation
	pass
	
