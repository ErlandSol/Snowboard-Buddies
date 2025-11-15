extends CanvasLayer
class_name ViewportManager
const CAMERA_VIEWPORT = preload("uid://dfhd2xcmkf367")

static var gridContainer: GridContainer
static var viewPortContainers : Array[SubViewportContainer]
static var preferVertical = true
var e = 1

static var Instance : ViewportManager = null
func _init():
	if Instance == null:
		Instance = self

	else:
		queue_free()


@export var b : Node3D


func Clear():
	for viewport in gridContainer.get_children():
		viewport.queue_free()
	pass
	
func Update():
	viewPortContainers.clear()
	viewPortContainers.append_array(gridContainer.get_children(false))
	#print(viewPortContainers.size())
	if (preferVertical): e = 2
	else: e = 1

	if viewPortContainers.size() <= e:
		gridContainer.columns = 1
	elif (preferVertical == false and viewPortContainers.size() >= 3) or viewPortContainers.size() >= 6:
		gridContainer.columns = 3
	else:
		gridContainer.columns = 2	

		
func AddCamera(target : Node3D = null):
	gridContainer = $"Viewport grid"
	var instance = CAMERA_VIEWPORT.instantiate()
	if not instance is CameraViewport: return
	if not target == null:
		instance.cameraController.SetTarget(target)
	gridContainer.add_child(instance)
	
	Update()
	return instance

	
