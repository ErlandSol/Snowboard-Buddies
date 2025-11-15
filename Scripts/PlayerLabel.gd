extends Label3D
@onready var player: Player = $"../.."



func _process(delta: float) -> void:
	text = "Player " + str(player.id) + " | Position: " + str(player.racePosition)
