extends Area2D

var entered := false
var teleporting := false
@onready var player = get_tree().get_first_node_in_group("Player")
func _ready() -> void:
	$ColorRect/Label.text = str(Global.level_data["level3"]) + "/5"
	if Global.currentLevel+1 > 2:
		$Frames.visible = true
	else:
		$Frames.visible = false
func _on_body_entered(body):
	if Global.currentLevel+1 > 2:
		if body is Player: # Bezpieczniejsze sprawdzenie
			print("Wszedles")
			entered = true

func _on_body_exited(_body):
	entered = false

func _process(_delta):
	if entered and not teleporting:
		if Input.is_action_just_pressed("teleport"):
			teleporting = true
			if player:
				player.start_portal_effect(true) 
			$EnterTimer.start()

func _on_enter_timer_timeout():
	Global.restart_entire_run()
	Global.target_spawn_name = "MenuStart" 
	Global.spawn_position = Vector2(295, 405) 
	GlobalLoader.load_level("res://level_4.tscn") 
	Global.restart_entire_run()
#d
