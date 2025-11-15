extends Node3D
class_name Level

@export var levelStart : LevelStart
@onready var path3d: Path3D = $Path3D


func getPlayerProgress(player: Player) -> float:
	if not player: return 0.0
	if not path3d: return 0.0
	var target_global_pos: Vector3 = player.global_transform.origin
	var target_local_pos: Vector3 = path3d.to_local(target_global_pos)
	var offset: float = path3d.curve.get_closest_offset(target_local_pos)
	return offset
