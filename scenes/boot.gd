extends Node

func _ready():
	if Global.currentLevel+1 > 1:
		GlobalLoader.load_level("res://scenes/level.tscn") 
	else:
		GlobalLoader.load_level("res://scenes/level_2.tscn") 
