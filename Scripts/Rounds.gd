extends Node
class_name Rounds

class Race:
	static var AuroraAlps 		: Round = Round.new(Levels.AuroraAlps,		Round.Types.Race, 3)
	static var PeacefulPeaks 	: Round = Round.new(Levels.PeacefulPeaks,	Round.Types.Race, 3)

class TimeTrial:
	static var AuroraAlps 		: Round = Round.new(Levels.AuroraAlps,		Round.Types.TimeTrial, 1)
	static var PeacefulPeaks 	: Round = Round.new(Levels.PeacefulPeaks,	Round.Types.TimeTrial, 1)

class Freestyle:
	static var AuroraAlps 		: Round = Round.new(Levels.AuroraAlps,		Round.Types.Freestyle, 1)
	static var PeacefulPeaks 	: Round = Round.new(Levels.PeacefulPeaks,	Round.Types.Freestyle, 1)
