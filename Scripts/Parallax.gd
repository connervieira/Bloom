extends Node2D

var CameraNode = Node

var VerticalOffset = 300 #Determines how far down the parallax effect is moved in relation to the camera

func _ready():
	if get_tree().get_current_scene().get_name() == "World1":
		CameraNode = get_tree().root.get_node("World1").get_node("Camera")
	elif get_tree().get_current_scene().get_name() == "World2":
		CameraNode = get_tree().root.get_node("World2").get_node("Camera")
	elif get_tree().get_current_scene().get_name() == "World3":
		CameraNode = get_tree().root.get_node("World3").get_node("Camera")
	elif get_tree().get_current_scene().get_name() == "World4":
		CameraNode = get_tree().root.get_node("World4").get_node("Camera")
	elif get_tree().get_current_scene().get_name() == "World5":
		CameraNode = get_tree().root.get_node("World5").get_node("Camera")
	elif get_tree().get_current_scene().get_name() == "World6":
		CameraNode = get_tree().root.get_node("World6").get_node("Camera")

func _process(delta):
	self.get_child(0).position.x = CameraNode.position.x/2
	self.get_child(0).position.y = (CameraNode.position.y/4)+300
	
	self.get_child(1).position.x = CameraNode.position.x/3
	self.get_child(1).position.y = (CameraNode.position.y/9)+300
	
	self.get_child(2).position.x = CameraNode.position.x/5
	self.get_child(2).position.y = (CameraNode.position.y/25)+300
	
	self.get_child(3).position.x = CameraNode.position.x/100
	self.get_child(3).position.y = (CameraNode.position.y/1000)+300
