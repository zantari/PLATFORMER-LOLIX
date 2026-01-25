extends CanvasLayer


var scena = "res://scenes/level.tscn"


func _ready() -> void:
	$MarginContainer2/reszta.text = "LEVEL: "+ str(Global.passedLevel+1)+ "
	\nDEATHS: " + str(Global.deaths) + "
	\nDIAMONDS: " + str(Global.uzbieraneDiamenty) +"/"+str(Global.naIleDiamentow)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene_to_file(scena)
func _on_button_pressed() -> void:
	print("halo")
	get_tree().change_scene_to_file(scena)
