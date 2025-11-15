extends CharacterBody3D
class_name Board
#@export var ray_cast: RayCast3D

@onready var shape: CollisionShape3D = $Shape
@onready var mesh: Node3D = $Shape/Mesh
#@onready var camera_hinge: Node3D = $"Camera hinge"

var dist: float = 0.0
var targetPos: Vector3 = Vector3.ZERO

var xform : Transform3D
var turnSpeed = 10


@export var gravity = Vector3(0, -20, 0)
var maxSpeed = 20
@export var max_fall_speed = 20
@export var baseTurnSpeed = 10
@export var baseMaxSpeed = 15
#@export var baseCarveSpeed = 10


var xInput := 0.0

var forwardDirection: Vector3
var sideDirection: Vector3
var upDirection: Vector3

var canJump = true

var braking = false
var drift = false
var carving = false

var carveStartRotation := 0.0
var carveTargetRotation := 0.0

var forwardFriction = 0.998  # less friction
var sideFriction = 0.7      # more friction
var board_rotation_y := 0.0
var carveSpeed := 0.0
var carveTime := 0.0
var carveDir = 0

var turnVelocity := 0.0
var turnRotation := 0.0

var jumpBuffer := Buffer.new(0.15, 0.15, true)

func _ready() -> void:
	targetPos = position
	


	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		xInput = 1
		#rotation.y += 0.01
	elif Input.is_action_pressed("right"):
		xInput = -1
		#rotation.y -= 0.01
	else:
		xInput = 0
	
	turnVelocity = (turnSpeed+carveSpeed) * 0.001 * xInput
	rotation.y += turnVelocity
	turnRotation = turnVelocity
			
	if Input.is_action_pressed("back") and xInput != 0:	
		carving = true
		carveDir = xInput
	else:
		carving = false
		
	if carving:
		carveTime += delta
		var b = 0.99
		maxSpeed = baseMaxSpeed
		if carveTime <= .5: carveSpeed = 8
		if carveTime > .5: 	
			carveSpeed = 12
			maxSpeed = baseMaxSpeed * 0.75
		if carveTime > 1.5:	
			carveSpeed = 20
			maxSpeed = baseMaxSpeed * 0.5
			b = 0.95
		if xInput != carveDir: carving = false
		
		#velocity = velocity * b
		carveSpeed = carveSpeed * velocity.length() * 0.1
		
	else:
		maxSpeed = 20
		carveSpeed = 0.0
		carveTime = 0.0
		
	#print(carveTime)
	#print(velocity.length()*0.1)	
	forwardDirection = -transform.basis.z.normalized()
	sideDirection = transform.basis.x.normalized()
	upDirection = transform.basis.y.normalized()
	var forwardSpeed = velocity.dot(forwardDirection)
	var sideSpeed = velocity.dot(sideDirection)	
	
	
	if is_on_floor():
		#apply_floor_snap()
		var groundNormal = get_floor_normal()
		#AlignWithGround(groundNormal,delta)
		#get_floor_angle()
		var gravityDirection: Vector3 = gravity.normalized()
		var downhillDirection: Vector3 = gravityDirection.slide(groundNormal).normalized()
		var slopeAcceleration: Vector3 = downhillDirection * gravity.length()
		
		forwardSpeed *= forwardFriction
		sideSpeed *= sideFriction
	
		#velocity = (forwardDirection * forwardSpeed) + (sideDirection * sideSpeed)
		#velocity += slopeAcceleration * delta

		# Limit speed
		#if velocity.length() > maxSpeed:
			#velocity = velocity.normalized() * maxSpeed
	#else:
	velocity += Vector3.DOWN * 10 * delta
	#velocity = velocity.normalized() * 10
	#print(velocity)
	jumpBuffer.update(Input.is_action_just_pressed("jump"), is_on_floor(), delta)

	if jumpBuffer.should_run_action():
		velocity = 3 * upDirection
		velocity += forwardDirection * 5 * velocity.length()
		
	move_and_slide()
	
	
func AlignWithGround(normal: Vector3, delta: float) -> void:
	xform = shape.global_transform
	xform.basis.y = normal
	xform.basis.x = -xform.basis.z.cross(normal)
	xform.basis = xform.basis.orthonormalized()
	shape.global_transform = shape.global_transform.interpolate_with(xform,delta*20)
	shape.rotation.y = board_rotation_y
	shape.rotation.z = lerp_angle(shape.rotation.z, turnRotation * 40, delta*20 )
	
	
	var sideNormal = normal.dot(sideDirection.normalized())
	var velocityCutoff = velocity.dot(forwardDirection.normalized())/50

	if (abs(velocityCutoff) < abs(sideNormal)):
		rotate_y(sideNormal*-0.02)
		#velocity += forwardDirection * 100
