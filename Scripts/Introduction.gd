extends MarginContainer

const IntroductionLength = 53 # 53 seconds
var time = 0

func _process(delta):
	time += delta
	if Input.is_action_pressed("ui_end"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn") # Return to the main menu
	if time > IntroductionLength:
		get_tree().change_scene("res://Scenes/MainMenu.tscn") # After the introduction is done playing, return to the menu
