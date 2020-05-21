extends Camera2D

var Player = Node

var distanceMode = false

func _ready():
	Player = get_parent().get_node("Player")
	pass
	
func _process(delta):
	if Player != null:
		position = position + ((Player.position - position) / 10)
		
	pass
