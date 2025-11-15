@tool
extends Node3D
class_name SlopePath


class SlopePathSection:
	var position := Vector3.ZERO
	var width := 1.0
	
	

var pathArray : Array[SlopePathSection]
