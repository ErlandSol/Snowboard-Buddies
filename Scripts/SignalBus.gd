extends Node

@warning_ignore_start("unused_signal")

signal OnPlayerEnterGoalArea(player)
signal OnPlayerEnterSkiLift(player)
signal OnPlayerExitSkiLift(player)
signal OnPlayerExitStartLift(player)

signal OnPlayerHit(player,hitBy,causedBy)
signal OnPlayerFall(player)
signal OnPlayerJump(player)
