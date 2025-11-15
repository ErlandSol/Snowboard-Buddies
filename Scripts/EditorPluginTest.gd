extends EditorPlugin

func _handles(object: Object) -> bool:
	if object is Node3D:
		print("found")
		return true
	else: 
		return false 
	
