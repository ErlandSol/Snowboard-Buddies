extends CharacterBody3D


var currentFloorNormal = Vector3.ZERO
var forwardDirection = Vector3.ZERO
var sideDirection = Vector3.ZERO
var upDirection = Vector3.ZERO
var turnSpeed = 0
var maxTurnSpeed = 20
var followingPlayer : Player = null
var _owner : Player = null



func FollowPath(delta):
	var path3d = Game.currentLevel.path3d
	var target_global_pos: Vector3 = position + velocity * forwardDirection*5
	var target_local_pos: Vector3 = path3d.to_local(target_global_pos)
	var g =  path3d.curve.get_closest_point(target_local_pos)
	var b = (g-global_position)
	turnSpeed = b.dot(sideDirection)
	turnSpeed = clamp(turnSpeed,-1,1)
	rotate_y(turnSpeed*delta)

func FollowPlayer(player: Player,delta):
	var b = (player.global_position-global_position)
	turnSpeed = b.dot(sideDirection)
	turnSpeed = clamp(turnSpeed,-1,1)
	rotate_y(turnSpeed*delta)

func _physics_process(delta: float) -> void:
	
	if followingPlayer:
		FollowPlayer(followingPlayer,delta)
	else:
		FollowPath(delta)
	
	
	
	forwardDirection = transform.basis.z.normalized()
	sideDirection = transform.basis.x.normalized()
	upDirection = transform.basis.y.normalized()
	
	if is_on_floor():
		#var sideNormal = currentFloorNormal.dot(sideDirection.normalized())
		var yVelocity = velocity.y
		velocity.y = 0
		velocity = velocity.length() * forwardDirection * sign(velocity.dot(forwardDirection))
		velocity.y = yVelocity
		
	velocity.x = clamp(velocity.x, -20,20)
	velocity.z = clamp(velocity.z, -20,20)
	velocity += Vector3.DOWN * 10 * delta
	
	move_and_slide()




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if not body == _owner:
			followingPlayer = body
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == followingPlayer:
		followingPlayer = null
	pass # Replace with function body.


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		if not body == _owner:
			body.BecomeSnowman()
			queue_free()
	pass # Replace with function body.
