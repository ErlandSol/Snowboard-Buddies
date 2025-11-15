extends Node3D
#class_name Board

@onready var ray_cast_3d: RayCast3D = $Shape/RayCast3D
@onready var shape: CollisionShape3D = $Shape
@onready var mesh: Node3D = $Shape/Mesh

var dist: float = 0.0
var targetPos: Vector3 = Vector3.ZERO

var xform : Transform3D
var turnSpeed = 10

@export var gravity = Vector3(0, -10, 0)
var maxSpeed = 20
@export var max_fall_speed = 20
@export var baseTurnSpeed = 10
@export var baseMaxSpeed = 15
#@export var baseCarveSpeed = 10

var velocity = Vector3.ZERO
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
	#velocity += Vector3.DOWN * 10 * delta
	forwardDirection = -transform.basis.z.normalized()
	sideDirection = transform.basis.x.normalized()
	position += delta * (forwardDirection * velocity.z) 
	position += delta * (Vector3.UP * velocity.y) 
	position += delta * (sideDirection * velocity.x) 
	
	
	
	
	
	if ray_cast_3d.is_colliding():
		position.y = ray_cast_3d.get_collision_point().y + 0.1
		#position.y = clamp(position.y,  ray_cast_3d.get_collision_point().y,position.y)
		var normal = ray_cast_3d.get_collision_normal()
		#print(normal.dot(forwardDirection.normalized()))
		
		var gravityDirection: Vector3 = gravity.normalized()
		var downhillDirection: Vector3 = gravityDirection.slide(normal).normalized()
		var slopeAcceleration: Vector3 = downhillDirection * gravity.length()
		
		
		velocity.z += -slopeAcceleration.z * delta * 0.1
		print(normal.dot(forwardDirection.normalized())*1000)
		AlignWithGround(normal,delta)
	
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

	
	
	jumpBuffer.update(Input.is_action_just_pressed("jump"), true, delta)

	if jumpBuffer.should_run_action():
		velocity = 3 * Vector3.UP
		velocity.z  += 10

	
func AlignWithGround(normal: Vector3, delta: float) -> void:
	var sideNormal = normal.dot(sideDirection.normalized())
	xform = global_transform
	xform.basis.y = normal
	xform.basis.x = -xform.basis.z.cross(normal)
	xform.basis = xform.basis.orthonormalized()
	global_transform = global_transform.interpolate_with(xform,delta*20)

	
	
	
	var velocityCutoff = velocity.z/50
	#print(rotation.z)
	#if (abs(velocityCutoff) < abs(sideNormal)):
	rotate_y(rotation.z*0.05)
		#velocity += forwardDirection * 100
