extends Node
class_name Util

static func Delay(seconds: float):
	await Game.get_tree().create_timer(seconds).timeout
	return
