extends Node2D

var Player = Node
var LastFramePlayer = Node

var SeekPlayer = false

func _ready():
	LastFramePlayer = Player
func _process(delta):
	if SeekPlayer == true:
		position = position + ((Player.position + ((Player.position - position)) - position) / 40)
		
		if abs(Player.position.x - position.x) <= 5 and abs(Player.position.y - position.y) <= 5:
				SeekPlayer = false
		elif abs(Player.position.x - position.x) <= 10 and abs(Player.position.y - position.y) <= 10:
			position = position + ((Player.position - position)/1.25)
		elif abs(Player.position.x - position.x) <= 20 and abs(Player.position.y - position.y) <= 20:
			position = position + ((Player.position - position)/1.5)
		elif abs(Player.position.x - position.x) <= 40 and abs(Player.position.y - position.y) <= 40:
			position = position + ((Player.position - position) / 5)
		elif abs(Player.position.x - position.x) <= 100 and abs(Player.position.y - position.y) <= 100:
			position = position + ((Player.position - position) / 10)
		elif abs(Player.position.x - position.x) <= 200 and abs(Player.position.y - position.y) <= 200:
			position = position + ((Player.position - position) / 20)
	else:
		if Player == LastFramePlayer:
			position = Player.position
		else:
			SeekPlayer = true
	LastFramePlayer = Player
	pass
