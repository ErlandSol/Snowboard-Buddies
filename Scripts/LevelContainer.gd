extends Node3D
class_name LevelContainer

static var Instance = null

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()
		
		
#func _ready() -> void:
	#Levels.Load(Levels.AuroraAlps,self)
