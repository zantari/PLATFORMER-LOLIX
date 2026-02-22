extends Control
var cr = "nic"

# --- REFERENCJE DO WĘZŁÓW (Zgodnie z Twoim zdjęciem) ---
@onready var click_sound = $ClickSound
@onready var menu_kontener = $PanelContainer/kontenerMENU
@onready var are_you_sure_kontener = $PanelContainer/kontenerAREUSURE
@onready var are_you_sure_label = $PanelContainer/kontenerAREUSURE/Label

# Przyciski do Focusa
@onready var resume_button = $PanelContainer/kontenerMENU/RESUME
@onready var no_button = $PanelContainer/kontenerAREUSURE/NO
@onready var focus_sound = $FocusSound

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$AnimationPlayer.play("RESET")
	are_you_sure_label.text = "ARE YOU SURE?"
	menu_kontener.visible = true
	are_you_sure_kontener.visible = false
	
	setup_focus_sounds()

func setup_focus_sounds():
	# Szukamy wszystkich przycisków w obu kontenerach
	var buttons = menu_kontener.get_children() + are_you_sure_kontener.get_children()
	
	for node in buttons:
		if node is Button:
			# Podpinamy sygnał focus_entered do funkcji odtwarzającej dźwięk
			node.focus_entered.connect(_on_button_focus_entered)

func _on_button_focus_entered():
	# Odtwarzamy dźwięk tylko jeśli menu jest widoczne (żeby nie grało przy starcie)
	if self.visible and focus_sound:
		# Opcjonalnie: zmień wysokość dźwięku (pitch), żeby różnił się od kliknięcia
		focus_sound.pitch_scale = 1.2 
		focus_sound.play()
		
func play_click():
	if click_sound:
		click_sound.play()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	self.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Zwalniamy focus, żeby pad nie "klikał" w tle
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func pause():
	get_tree().paused = true
	cr = "nic"
	$AnimationPlayer.play("blur")
	self.show()
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Ustawiamy focus na przycisk RESUME (WIELKIE LITERY)
	if resume_button:
		resume_button.grab_focus()

func testEsc():
	if Input.is_action_just_pressed("esc"):
		if not get_tree().paused:
			Global.clear_ui.emit(self)
			menu_kontener.visible = true		
			are_you_sure_kontener.visible = false
			pause()
		else:
			resume()

# --- PRZYCISKI GŁÓWNE ---

func _on_resume_pressed() -> void:
	play_click()
	resume()

func _on_settings_pressed() -> void:
	play_click()
	cr = "resetGame"
	areusureShow()

func _on_reset_pressed() -> void:
	play_click()
	cr = "reset"
	areusureShow()
	
func _on_lobby_pressed() -> void:
	play_click()
	cr = "lobby"
	areusureShow()
	
func _on_quit_pressed() -> void:
	play_click()
	cr = "quit"
	areusureShow()

# --- PRZYCISKI POTWIERDZENIA ---

func _on_yes_pressed() -> void:
	play_click()
	if cr == "quit":
		get_tree().quit()
	elif cr == "lobby":
		resume()
		Global.target_spawn_name = 'MenuStart'
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	elif cr == "reset":
		resume()
		Global.target_spawn_name = 'MenuStart'
		Global.restart_entire_run_z_lobby()
	elif cr == "resetGame":
		resume() 
		Global.reset_game()
	cr = "nic"

func _on_no_pressed() -> void:
	play_click()
	# Powrót do głównego menu pauzy
	are_you_sure_kontener.visible = false
	menu_kontener.visible = true
	if resume_button:
		resume_button.grab_focus()

func areusureShow():
	if cr == "resetGame":
		are_you_sure_label.text = "THIS WILL RESET THE WHOLE GAME\nARE YOU SURE?"
	else:
		are_you_sure_label.text = "ARE YOU SURE?"
		
	menu_kontener.visible = false
	are_you_sure_kontener.visible = true
	
	# Focus na przycisk NO (WIELKIE LITERY)
	if no_button:
		no_button.grab_focus()

func _process(_delta: float) -> void:
	testEsc()
