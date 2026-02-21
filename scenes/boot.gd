extends Node

func _ready():
	if Global.currentLevel+1 > 1:
		GlobalLoader.load_level("res://scenes/level.tscn") 
	else:
		Global.last_checkpoint_pos = Vector2(299.0, 439.0)
		GlobalLoader.load_level("res://scenes/level_2.tscn") 
