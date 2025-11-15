extends Node3D
class_name CameraController

var target : Node3D
var camera : Camera3D
static var rotationSpeed := 2.0
static var moveSpeed := 10.0
#var positionOffset := Vector3.ZERO
var rotationOffset := Vector3.ZERO
#var forwardDirection : Vector3

func SetTarget(_target: Node3D):
	self.target = _target

func _physics_process(delta: float) -> void:
	#forwardDirection = -transform.basis.z.normalized()
	followTarget(delta)
	
	
func followTarget(delta : float):
	if (target == null): return
	position = position.lerp(target.position,delta*moveSpeed)
	rotation.x = lerp_angle( rotation.x, target.global_rotation.x + rotationOffset.x, delta*rotationSpeed )
	rotation.y = lerp_angle( rotation.y, target.global_rotation.y + rotationOffset.y, delta*rotationSpeed )
	rotation.z = lerp_angle( rotation.z, target.global_rotation.z + rotationOffset.z, delta*rotationSpeed ) 

	
func teleportToTarget():
	if (target == null): return
	position = target.position
	rotation = target.global_rotation + rotationOffset
	pass
	
