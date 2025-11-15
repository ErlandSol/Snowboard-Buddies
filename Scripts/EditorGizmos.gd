extends Node3D

@export var enabledInPlayMode := false

func _ready() -> void:
	if enabledInPlayMode: return
	queue_free()
