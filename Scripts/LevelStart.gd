extends Node3D
class_name LevelStart

func GetSpawnLocations():
	return $"Spawn Locations".get_children()
