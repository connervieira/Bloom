extends KinematicBody2D

const UP = Vector2(0, -1)
#const GRAVITY = 0.01 # move_and_collide gravity
const GRAVITY = 5 # move_and_slide gravity
#const SPEED = 10 # move_and_collide speed
const SPEED = 300 # move_and_slide speed
#const JUMPFORCE = 10 # move_and_collide jumpforce
const JUMPFORCE = 300 # move_and_slide jumpforce
const GROUNDPOUNDFORCE = 500
const FRICTION = 1.05
const ACCELERATION = 50 # The speed at which the player accelerates. The higher the number, the slower the accelerations

var objectHit = Vector2()
var motion = Vector2()
var squishFactor = Vector2(1,1)
var hasGroundPounded = false
var dead = false


var savePath = "user://savefile.cfg"
var saveFile = ConfigFile.new()

var lastFrameMotion = Vector2()

var progress = { # Load default progress database as a placeholder to be loaded to by load_progress() upon level completion
	"Levels": {
		"Level1": true,
		"Level2": false,
		"Level3": false,
		"Level4": false,
		"Level5": false,
		"Level6": false
	}
}

var currentWorld = "DefaultWorld" # Placeholder to be filled once the Player determines what world it is in
var respawnPower = 100000000

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

func _ready():
	objectHit = move_and_collide(motion) # Monitor for collisions
	if get_tree().get_current_scene().get_name() == "World1":
		get_tree().root.get_node("World1").get_node("Camera").Player = self
		get_tree().root.get_node("World1").get_node("Eyes").Player = self
		respawnPower = 100000000 # Effectively give the player infinite respawns
		currentWorld = "World1"
		
	elif get_tree().get_current_scene().get_name() == "World2":
		get_tree().root.get_node("World2").get_node("Camera").Player = self
		get_tree().root.get_node("World2").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 3
		currentWorld = "World2"
		
	elif get_tree().get_current_scene().get_name() == "World3":
		get_tree().root.get_node("World3").get_node("Camera").Player = self
		get_tree().root.get_node("World3").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 2
		currentWorld = "World3"
		
	elif get_tree().get_current_scene().get_name() == "World4":
		get_tree().root.get_node("World4").get_node("Camera").Player = self
		get_tree().root.get_node("World4").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 8
		currentWorld = "World4"
		
	elif get_tree().get_current_scene().get_name() == "World5":
		get_tree().root.get_node("World5").get_node("Camera").Player = self
		get_tree().root.get_node("World5").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 2
		currentWorld = "World5"
		
	elif get_tree().get_current_scene().get_name() == "World6":
		get_tree().root.get_node("World6").get_node("Camera").Player = self
		get_tree().root.get_node("World6").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 5
		currentWorld = "World6"
		
		
		
	elif get_tree().get_current_scene().get_name() == "Procedural":
		get_tree().root.get_node("Procedural").get_node("Camera").Player = self
		get_tree().root.get_node("Procedural").get_node("Eyes").Player = self
		if self.get_name() == "Player":
			respawnPower = 5
		currentWorld = "Procedural"
	
func die():
	if respawnPower <= 1:
		get_tree().change_scene("res://Scenes/MainMenu.tscn") # If the player dies, and there isn't any respawn power left, return to the main menu
	set_name("Corpse")
	var scene = load("res://Prefabs/Player.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("RespawnedPlayer")
	get_tree().get_root().add_child(scene_instance)
	scene_instance.respawnPower = respawnPower - 1
	dead = true
	
func _process(delta):
	if dead == false:
		if position.y >= 1000:
			die()
	if Input.is_action_pressed("ui_end"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn") # If the player dies, and there isn't any respawn power left, return to the main menu
		
	if currentWorld != "World1" and currentWorld != "Control":
		if get_tree().root.get_node(currentWorld):
			if get_tree().root.get_node(currentWorld).get_node("Control"):
				if get_tree().root.get_node(currentWorld).get_node("Control").get_node("RespawnPower"):
					get_tree().root.get_node(currentWorld).get_node("Control").get_node("RespawnPower").set_text("Respawn Power:" + str(respawnPower-1))
	if get_tree().root.get_node("Control"):
		if get_tree().root.get_node("Control").get_node("MenuIndicator"):
			get_parent().remove_child(self)

func _physics_process(delta):
	motion.y += GRAVITY
	lastFrameMotion = motion
	if dead == false:
		if Input.is_action_pressed("ui_cancel"):
			get_tree().change_scene("res://Scenes/MainMenu.tscn") # If the player dies, and there isn't any respawn power left, return to the main menu
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
			motion.x = motion.x/FRICTION
		elif Input.is_action_pressed("ui_right"):
			if motion.x > -2:
				motion.x = motion.x + abs(motion.x - SPEED)/ACCELERATION
			else:
				motion.x = motion.x/(FRICTION*1.5)
		elif Input.is_action_pressed("ui_left"):
			if motion.x < 2:
				motion.x = -(abs(motion.x) + abs(abs(motion.x) - SPEED)/ACCELERATION)
			else:
				motion.x = motion.x/(FRICTION*1.5)
		else:
			motion.x = motion.x/FRICTION
			
		if is_on_floor():
			hasGroundPounded = false
			if Input.is_action_pressed("ui_up"):
				motion.y = -JUMPFORCE
			
		if Input.is_action_pressed("ui_down") and hasGroundPounded == false and is_on_floor() == false:
			motion.y = GROUNDPOUNDFORCE
			hasGroundPounded = true # Indicate that the player has already groundpounded so they can't do it twice in one jump
		
		if objectHit:
			if objectHit.collider.is_in_group("Lava"):
				die() # Kill the current player
			if objectHit.collider.is_in_group("Level1Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level2"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
			if objectHit.collider.is_in_group("Level2Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level3"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
			if objectHit.collider.is_in_group("Level3Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level4"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
			if objectHit.collider.is_in_group("Level4Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level5"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
			if objectHit.collider.is_in_group("Level5Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level6"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
			if objectHit.collider.is_in_group("Level6Finish"):
				load_progress() # Load the player's progress database
				progress["Levels"]["Level7"] = true # Mark next level as unlocked
				save_progress() # Save the player's progress to disk
				get_tree().change_scene("res://Scenes/MainMenu.tscn") # After saving, load the main menu scene
	else:
		motion.x = motion.x/FRICTION
		
	motion = move_and_slide(motion, UP) # Monitor for collisions
	var random = randi()%5+1
	if random == 1:
		objectHit = move_and_collide(Vector2(0,0.05)) # Monitor for collisions
	elif random == 2:
		objectHit = move_and_collide(Vector2(0,-0.05)) # Monitor for collisions
	elif random == 3:
		objectHit = move_and_collide(Vector2(0.05,0)) # Monitor for collisions
	elif random == 4:
		objectHit = move_and_collide(Vector2(-0.05,0)) # Monitor for collisions
	pass
	
