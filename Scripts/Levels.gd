#extends Node
class_name Levels
static var PeacefulPeaks : PackedScene = preload("uid://dn0rpf87l260x")
static var AuroraAlps : PackedScene = preload("uid://yvgnsva8ldt0")


static func Load(level: PackedScene, parent: Node) -> Level:
	if level == null: 
		print("Error: Level prefab is null")
		return null
	if parent == null: 
		print("Error: Parent is null")
		return null
	var instantiatedLevel = level.instantiate()
	if not instantiatedLevel is Level: 
		print("Error: Instance is not of type Level")
		return null
	parent.add_child(instantiatedLevel)
	return instantiatedLevel
