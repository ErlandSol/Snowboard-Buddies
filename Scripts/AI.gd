extends CharacterBody3D
class_name AI


var avoidanceVector : Vector2
var interestVector : Vector2

var jumpAvoidance : float
var jumpInterest : float

var itemUseAvoidance : float
var itemUseInterest : float

var carveInterest : float
var carveAvoidance : float

var rayCount := 5

var avoidanceVectors : Array[Vector2] = []
var interestVectors : Array[Vector2] = []



func _ready() -> void:
	pass
