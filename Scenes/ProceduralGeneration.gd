extends Node2D

var placePosition = Vector2(160, 448)

func _ready():
	for i in range(20):
		print(placePosition)
		placePosition = Vector2(placePosition.x + 64, placePosition.y)
		var scene = load("res://Tiles/ProceduralWall.tscn") # Define the procedural wall tile
		var scene_instance = scene.instance() # Create an instance of the procedural wall tile
		scene_instance.position = placePosition # Set the instance's position to be at the place defined by the generation algorithm
		get_tree().get_root().add_child(scene_instance) # Add the instance to the main scene
	
