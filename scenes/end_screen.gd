extends CanvasLayer


var scenaLobby = "res://scenes/level.tscn"



func _ready() -> void:
	var poziomKtoryPrzeszedles = Global.passedLevel+1
	$MarginContainer2/reszta.text = "LEVEL: "+ str(poziomKtoryPrzeszedles)+ "
	\nDEATHS: " + str(Global.deaths) + "
	\nDIAMONDS: " + str(Global.uzbieraneDiamenty) +"/"+str(Global.naIleDiamentow)

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
		#get_tree().change_scene_to_file(scena)



func _on_next_button_pressed() -> void:
	print("next")
	Global.restart_entire_run()
	Global.target_spawn_name = "MenuStart" 
	Global.spawn_position = Vector2(295, 405) 
	GlobalLoader.load_level(Global.level_scenes[Global.passedLevel+1]) 
	Global.restart_entire_run()



func _on_lobby_button_pressed() -> void:
	get_tree().change_scene_to_file(scenaLobby)


func _on_again_button_pressed() -> void:
	Global.restart_entire_run()
	Global.target_spawn_name = "MenuStart" 
	Global.spawn_position = Vector2(295, 405) 
	GlobalLoader.load_level(Global.level_scenes[Global.passedLevel]) 
	Global.restart_entire_run()
