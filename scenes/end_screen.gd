extends CanvasLayer

var scenaLobby = "res://scenes/level.tscn"

# --- POPRAWIONE REFERENCJE (Zgodnie z Twoim zdjęciem) ---
@onready var next_btn = $nextButton
@onready var lobby_btn = $LobbyButton
@onready var again_btn = $AgainButton

func _ready() -> void:
	var poziomKtoryPrzeszedles = Global.passedLevel + 1
	$MarginContainer2/reszta.text = "LEVEL: " + str(poziomKtoryPrzeszedles) + \
		"\nDEATHS: " + str(Global.deaths) + \
		"\nDIAMONDS: " + str(Global.uzbieraneDiamenty) + "/" + str(Global.naIleDiamentow)
	
	var has_next_level = (Global.passedLevel + 1 < Global.level_scenes.size())
	
	
	next_btn.visible = has_next_level
	next_btn.disabled = !has_next_level

	# --- KONFIGURACJA PADA ---
	setup_navigation(has_next_level)

func setup_navigation(has_next: bool):
	# Czekamy chwilę na załadowanie UI
	await get_tree().process_frame
	
	# Podstawowe połączenie: Lobby <-> Again (środek)
	lobby_btn.focus_neighbor_right = again_btn.get_path()
	again_btn.focus_neighbor_left = lobby_btn.get_path()
	
	if has_next:
		# Układ: [Lobby] <-> [Again] <-> [Next]
		# Łączymy środek (Again) z prawą stroną (Next)
		again_btn.focus_neighbor_right = next_btn.get_path()
		next_btn.focus_neighbor_left = again_btn.get_path()
		
		# Startujemy od przycisku NEXT (prawo)
		next_btn.grab_focus()
	else:
		# Jeśli nie ma Next, Again (środek) nie ma nic po prawej
		again_btn.focus_neighbor_right = again_btn.get_path() # lub zostaw puste
		
		# Skoro nie ma Next, podświetlamy środek (Again)
		again_btn.grab_focus()

func _on_next_button_pressed() -> void:
	Global.restart_entire_run()
	Global.target_spawn_name = "MenuStart" 
	GlobalLoader.load_level(Global.level_scenes[Global.passedLevel+1]) 

func _on_lobby_button_pressed() -> void:
	get_tree().change_scene_to_file(scenaLobby)

func _on_again_button_pressed() -> void:
	Global.restart_entire_run()
	Global.target_spawn_name = "MenuStart" 
	GlobalLoader.load_level(Global.level_scenes[Global.passedLevel])
