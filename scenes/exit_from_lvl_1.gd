extends Area2D

@export_group("Ustawienia Przejścia")
@export_file("*.tscn") var target_scene_path: String # Wybierasz scenę z listy
@export var target_spawn_name: String = "DefaultSpawn" # Nazwa Markera w następnej scenie
var entered: bool = false
var teleporting: bool = false
@export var passedLevelodejmij1 = 0 
@export var ktoryLevel = "level1"
@export var kordyLobby: Vector2 = Vector2(317, 286)
func _on_body_entered(_body: PhysicsBody2D) -> void:
	if _body is Player:
		var player = _body
		
		player.can_shoot = false
		var label = $Label
		label.modulate.a = 1.0 
		label.visible = true

		var pulse = create_tween().set_loops()
		
		pulse.tween_property(label, "modulate:a", 0.3, 0.5).set_trans(Tween.TRANS_SINE)
		pulse.tween_property(label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)

		entered = true

func _on_body_exited(_body: PhysicsBody2D) -> void:
	if _body is Player:
		$Label.visible = false
		entered = false

func _process(_delta: float) -> void:
	if entered and not teleporting and Input.is_action_just_pressed("shoot"):
		start_teleportation()

func start_teleportation():
	teleporting = true
	
	# Pobieramy gracza, żeby odpalić efekt
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.start_portal_effect(true)
		
	# Czekamy na animację
	await get_tree().create_timer(1.0).timeout
	
	# ZAPISUJEMY NAZWĘ PUNKTU W GLOBALU
	Global.target_spawn_name = target_spawn_name
	Global.passedLevel = passedLevelodejmij1
	
	# Zmiana sceny
	Global.last_checkpoint_pos = kordyLobby
	Global.returnLobby(ktoryLevel, target_scene_path)
