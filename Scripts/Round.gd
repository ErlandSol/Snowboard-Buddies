extends Node
class_name Round

enum Types {Race, TimeTrial, Freestyle}
var type : Types
var laps : float
var level : PackedScene
#var players : Array[Player]
#var positions : Array[Player]
@warning_ignore("shadowed_variable")
func _init(level: PackedScene, type: Types, laps: int) -> void:
	self.level = level
	self.type = type
	self.laps = laps
