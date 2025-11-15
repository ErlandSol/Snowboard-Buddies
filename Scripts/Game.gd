extends Node

enum States {MainMenu, Shop, LevelSelect, Playing}
static var State: States = States.Playing

enum Modes {Singleplayer, Multiplayer, SplitScreen, TurnBased}
static var Mode : Modes = Modes.Singleplayer


var currentLevel: Level
var currentRound: Round

var playerPrefab : PackedScene = preload("uid://c1j2qrpth847e")

var players : Array[Player]
var playerPositions : Array[Player]

func Reset():
	players.clear()
	playerPositions.clear()
	currentLevel = null
	currentRound = null
	ViewportManager.Instance.Clear()
	pass

func _ready() -> void:
	StartRound(Rounds.Race.AuroraAlps)
	SignalBus.OnPlayerEnterGoalArea.connect(EnterGoal)


func StartRound(round, playerCount = 1, botCount = 4):
	currentRound = round
	currentLevel = Levels.Load(round.level,LevelContainer.Instance)
	SpawnPlayers(playerCount, botCount)

func EndRound():
	currentRound = null
	currentLevel.queue_free()
	Reset()
	

func SpawnPlayers(playerCount = 1, botCount = 4):
	var startPositions = currentLevel.levelStart.GetSpawnLocations()

	var currentID = 0
	for i in range(playerCount):
		var player : Player = playerPrefab.instantiate()
		players.append(player)
		currentLevel.add_child(player)
		player.position = startPositions[currentID].position#currentLevel.levelStart.position + (Vector3.LEFT * i * 2) 
		player.rotation = currentLevel.levelStart.rotation
	
		player.cameraViewport = ViewportManager.Instance.AddCamera(player)
		player.cameraController = player.cameraViewport.cameraController
		player.id = currentID
		player.NPC = false
		print(currentID)
		currentID += 1
		
	
	for i in range(botCount):
		var player : Player = playerPrefab.instantiate()
		players.append(player)
		currentLevel.add_child(player)
		player.position = startPositions[currentID].position#currentLevel.levelStart.position + (Vector3.RIGHT * (i+1) * 2) 
		player.rotation = currentLevel.levelStart.rotation
		player.id = currentID
		player.NPC = true
		print(currentID)
		currentID += 1
		#player.cameraViewport = ViewportManager.Instance.AddCamera(player)
		#player.cameraController = player.cameraViewport.cameraController
		
	playerPositions.append_array(players)
	pass




func EnterGoal(player):
	if player.currentLap < currentRound.laps:
		player.currentLap += 1
		print(str(player) + " is now on lap " + str(player.currentLap) + " and is in " + str(player.racePosition) +  ".place!")
	else:
		print(str(player) + " reached goal in " + str(player.racePosition) +  ".place!")
		await Util.Delay(.5)
		EndRound()
		await Util.Delay(1.5)
		StartRound(Rounds.Race.AuroraAlps)

	


func SortPlayerPositions(a: Player, b: Player) -> bool:
	if currentLevel.getPlayerProgress(a)+a.currentLap*10000 > currentLevel.getPlayerProgress(b)+b.currentLap*10000:
		return true
	return false


func _process(_delta: float) -> void:
	if not currentLevel: return
	if not currentRound: return
	playerPositions.sort_custom(SortPlayerPositions)
	var i = 0
	for player in playerPositions:
		i += 1
		player.racePosition = i
	pass
