extends Label
func _ready() -> void:
	if Global.currentScene != "lobby":
		text = str(Global.currentLevel)
	else:
		text = "Level: "+ str(Global.currentLevel)
	
func pokazLevel():
	if Global.currentScene == "lobby":
		text = "Current Level: " +str(Global.currentLevel+1)
	else:
		text = format_level_name(str(Global.currentScene))
		
		
func format_level_name(raw_name: String) -> String:
	var regex = RegEx.new()
	# Szukamy miejsca, gdzie litera styka się z cyfrą
	regex.compile("([a-zA-Z])(\\d)") 
	
	# Wstawiamy spację między grupę 1 (litera) a grupę 2 (cyfra)
	var spaced = regex.sub(raw_name, "$1 $2", true)
	
	# Wywalamy podkreślniki i zamieniamy na WIELKIE LITERY
	return spaced.replace("_", " ").to_upper()
