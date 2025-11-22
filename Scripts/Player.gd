extends CharacterBody3D
class_name Player

var NPC = false
var camera : Camera3D
var character : Character = null
var id := 0 # p1, p2 etc. | 0 counts as inactive/none
var money := 0
var score := 0
var currentLap := 1
var racePosition := 0

# -**- Board -**-
var board: Board
var collisionShape: CollisionShape3D
@export var boardMesh: Node3D
var xform : Transform3D

var currentFloorNormal = Vector3.ZERO
var forwardDirection = Vector3.ZERO
var sideDirection = Vector3.ZERO
var upDirection = Vector3.ZERO
var cameraViewport : CameraViewport = null
var cameraController : CameraController = null
var xInput := 0.0
var canJump = true

var jumpBuffer := Buffer.new(0.15, 0.15, true)

var maxTurnSpeed := 20.0
var turnSpeedMultiplier := 0.1
var turnSpeed := 0.0
var item: Item = null

@onready var raycast_front_left: RayCast3D = $"Raycasts/Raycast Front Left"
@onready var raycast_front_right: RayCast3D = $"Raycasts/Raycast Front Right"
@onready var raycast_back_left: RayCast3D = $"Raycasts/Raycast Back Left"
@onready var raycast_back_right: RayCast3D = $"Raycasts/Raycast Back Right"

var snowman := false
var parachute := false
var frozen := false

@onready var snowmanMesh: Node3D = $Snowman
const PROJECTILE = preload("uid://bc4q8ewew1svk")



func _ready():
	DebugDraw3D.scoped_config().set_thickness(0.02).set_center_brightness(0.5)

func GetRaycastNormal() -> Vector3:
	var normalFrontLeft := Vector3.ZERO
	var normalFrontRight := Vector3.ZERO
	var normalBackLeft := Vector3.ZERO
	var normalBackRight := Vector3.ZERO
	if raycast_front_left.is_colliding():
		normalFrontLeft = raycast_front_left.get_collision_normal()
	if raycast_front_right.is_colliding():
		normalFrontRight = raycast_front_right.get_collision_normal()
	if raycast_back_left.is_colliding():
		normalBackLeft = raycast_back_left.get_collision_normal()
	if raycast_back_right.is_colliding():
		normalBackRight = raycast_back_right.get_collision_normal()
	var normal := (normalFrontLeft + normalFrontRight + normalBackLeft + normalBackRight).normalized()
	return normal

func PlayerInput(delta):
	if Input.is_action_pressed("left"): xInput = 1
	elif Input.is_action_pressed("right"): xInput = -1
	else: xInput = 0
	jumpBuffer.update(Input.is_action_just_pressed("jump"), is_on_floor(), delta)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func NPCInput(delta):
	var path3d = Game.currentLevel.path3d
	var target_global_pos: Vector3 = position + forwardDirection*10
	var target_local_pos: Vector3 = path3d.to_local(target_global_pos)
	var g =  path3d.curve.get_closest_point(target_local_pos)
	var b = (g-global_position)
	turnSpeed = b.dot(sideDirection)
	turnSpeed = clamp(turnSpeed,-maxTurnSpeed*turnSpeedMultiplier,maxTurnSpeed*turnSpeedMultiplier)
	rotate_y(turnSpeed*delta)

func shoot():
	var p = PROJECTILE.instantiate()
	p._owner = self
	p.global_position = global_position + forwardDirection
	p.velocity = velocity + forwardDirection * 10 
	p.rotation = rotation
	Game.currentLevel.add_child(p)
	
	pass

func BecomeSnowman():
	snowman = true
	snowmanMesh.visible = true
	await Util.Delay(4)
	snowman = false
	snowmanMesh.visible = false
	pass
	
	
func _process(delta: float) -> void:
	if cameraViewport:
		cameraViewport.get_node("%LapLabel").text = str(currentLap) + "/" + str(roundi(Game.currentRound.laps))
		var suffix := "th"
		match racePosition:
			1: suffix = "st"
			2: suffix = "nd"
			3: suffix = "rd"
			#4: suffix = "th"
			
		cameraViewport.get_node("%PositionLabel").text = str(racePosition) + suffix
		#cameraViewport.apply_effect(velocity.dot(forwardDirection)*0.05)
	

func updateDirections():
	forwardDirection = transform.basis.z.normalized()
	sideDirection = transform.basis.x.normalized()
	upDirection = transform.basis.y.normalized()

func GroundedBehaviour(delta):
	var normal = GetRaycastNormal()
	currentFloorNormal = currentFloorNormal.lerp(normal,delta*5)
	AlignWithGround(currentFloorNormal,delta)
	
	var acceleration = delta * forwardDirection * currentFloorNormal.dot(forwardDirection) * 3000
	velocity += acceleration * delta
	var sideNormal = currentFloorNormal.dot(sideDirection.normalized())
	if sign(sideNormal) == sign(xInput) or NPC:
		rotate_y(sideNormal*0.02)
	var yVelocity = velocity.y
	velocity.y = 0
	velocity = velocity.length() * forwardDirection * sign(velocity.dot(forwardDirection))
	velocity.y = yVelocity	

func ClampVelocity():
	velocity.x = clamp(velocity.x, -20,20)
	velocity.z = clamp(velocity.z, -20,20)	

func ApplyGravity(delta):
	velocity += Vector3.DOWN * 10 * delta

func JumpLogic():
	if jumpBuffer.should_run_action():
		velocity.y = 3
		velocity += forwardDirection.normalized() * 1.5	

func TurnLogic(delta):
	var turnVelocity = 17 * 0.001 * xInput
	rotation.y += turnVelocity	
	
func _physics_process(delta: float) -> void:	
	if not snowman:
		if NPC: NPCInput(delta)
		else: PlayerInput(delta)

	if is_on_floor():
		GroundedBehaviour(delta)

	TurnLogic(delta)
	ClampVelocity()
	ApplyGravity(delta)
	JumpLogic()
	move_and_slide()

func AlignWithGround(normal: Vector3, delta: float) -> void:
	xform = boardMesh.global_transform
	xform.basis.y = normal
	xform.basis.x = -xform.basis.z.cross(normal)
	xform.basis = xform.basis.orthonormalized()
	boardMesh.global_transform = boardMesh.global_transform.interpolate_with(xform,delta*5)
	boardMesh.scale = Vector3.ONE
	boardMesh.rotation.y = 0
