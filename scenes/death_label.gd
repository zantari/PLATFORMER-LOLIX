extends Label
func _ready() -> void:
	if Global.currentScene != "lobby":
		wyswietlijSmierci() 
	else:
		text = ""
	

func zniknijSmierci():
	text = ""
	Global.deaths = 0


func wyswietlijSmierci():
   
	var current_total = Global.deaths
	text = "Deaths: " + str(current_total) 
	
   
