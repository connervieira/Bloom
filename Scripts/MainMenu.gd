extends Node

var savePath = "user://savefile.cfg"
var saveFile = ConfigFile.new()

var progress = { # Default progress database to be used if no progress database is able to be loaded
	"Levels": {
		"Level1": true, # Level 1 should be unlocked by default
		"Level2": false,
		"Level3": false,
		"Level4": false,
		"Level5": false,
		"Level6": false
	}
}

var tips = [
	"Oliver is slightly less than the size of a block, meaning you can stand on the corner of a block that already has a robot on it!",
	"Oliver can jump just over two blocks, which means that while he can only make 2 block tall jumps, he can still touch blocks that are three blocks above the ground",
	"Oliver isn't strong enough to move broken robots, so make sure he doesn't get stuck under or behind one!",
	"If he's quick, sometimes Oliver can touch heat without breaking. If you're trying to break the robot to get a new one, make sure you push against the heat. If not, try to use this to your advantage!",
	"You'll only be able to see your Respawn Power at the spawn point of each level, so keep an eye on it each time you respawn!",
	"Most levels can be completed without using up all of the alloted Respawn Power, so if you're looking for a challenge, try to find spots where Oliver save respawns!",
	"In the event that you get stuck, you can press the escape key to restart a level and return to the menu.",
	"Building up speed is a great way to make it easier for Oliver to make longer jumps! If you're having a hard time making a jump, trying building up speed before it."
]
func save_progress():
	for section in progress.keys():
		for key in progress[section]:
			saveFile.set_value(section, key, progress[section][key])
	saveFile.save(savePath)
	
func load_progress():
	var error = saveFile.load(savePath)
	if error != OK:
		print("Failed to load progress file. Error code: %s" % error)
		return []
	
	for section in progress.keys():
		for key in progress[section]:
			progress[section][key] = saveFile.get_value(section, key, progress[section][key])

# Called when the node enters the scene tree for the first time.
func _ready():
	load_progress() # Load the player's progress from disk
	
	randomize() # Randomize the Godot's internal number generator to make sure the 'randi()' function called in the next line gives a more random number
	get_tree().root.get_node("Control").get_node("Tips").text = tips[randi() % tips.size()] # Pick a random tip from the database and display it
	
	# Determine which levels have been passed, and unlock level buttons accordingly
	if progress["Levels"]["Level2"] == false:
		get_tree().root.get_node("Control").get_node("ScrollContainer").get_node("VBoxContainer").get_node("Level2").disabled = true
	if progress["Levels"]["Level3"] == false:
		get_tree().root.get_node("Control").get_node("ScrollContainer").get_node("VBoxContainer").get_node("Level3").disabled = true
	if progress["Levels"]["Level4"] == false:
		get_tree().root.get_node("Control").get_node("ScrollContainer").get_node("VBoxContainer").get_node("Level4").disabled = true
	if progress["Levels"]["Level5"] == false:
		get_tree().root.get_node("Control").get_node("ScrollContainer").get_node("VBoxContainer").get_node("Level5").disabled = true
	if progress["Levels"]["Level6"] == false:
		get_tree().root.get_node("Control").get_node("ScrollContainer").get_node("VBoxContainer").get_node("Level6").disabled = true



func _on_Intro_pressed():
	get_tree().change_scene("res://Scenes/Introduction.tscn")


func _on_Level1_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Level2_pressed():
	get_tree().change_scene("res://Scenes/Level2.tscn")


func _on_Level3_pressed():
	get_tree().change_scene("res://Scenes/Level3.tscn")


func _on_Level4_pressed():
	get_tree().change_scene("res://Scenes/Level4.tscn")


func _on_Level5_pressed():
	get_tree().change_scene("res://Scenes/Level5.tscn")


func _on_Level6_pressed():
	get_tree().change_scene("res://Scenes/Level6.tscn")
