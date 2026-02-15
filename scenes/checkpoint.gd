extends Area2D

@onready var checkpoint_label: Label = $CheckpointUI/CheckpointLabel
@export var is_starting_checkpoint: bool = false 
@onready var player = get_tree().get_first_node_in_group("Player")
var was_activated: bool = false 
var ui_tween: Tween
var ZombieTexts: Array[String] = [
	"Aim for the head!",
	"They like brains",
	"Try press Q",
	"You can shoot by LMB or E",
	"Nice try",
	"Zombies are the best",
	"Not even close"
]
var deadTexts: Array[String] = [
	"Try again!",
	"Not your day?",
	"Is that all?",
	"That was close",
	"Nice try",
	"AVOID LAVA!!",
	
]
func _ready() -> void:
	Global.clear_ui.connect(_on_clear_ui)
	if checkpoint_label:
		checkpoint_label.modulate.a = 0
		checkpoint_label.visible = false
	
	
	var dist = Global.last_checkpoint_pos.distance_to(global_position)
	
	
	if dist < 20: #odradzanie
		was_activated = true 
		player.has_gun = true
		if Global.lastSlayer == "zombie":
			checkpoint_label.text = ZombieTexts.pick_random()
		else:
			checkpoint_label.text = deadTexts.pick_random()
		show_checkpoint_animation()

	
	elif is_starting_checkpoint:
		was_activated = true 

func _on_clear_ui(caller):
	if caller == self: 
		return
		
	if ui_tween: 
		ui_tween.kill()
		
	if checkpoint_label:
		checkpoint_label.visible = false
		checkpoint_label.modulate.a = 0
		
func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player") and not was_activated:
		print("NOWY CHECKPOINT NA POZYCJI ", global_position)
		
		Global.last_checkpoint_pos = global_position
		Global.save_progress_at_checkpoint()
		
		
		
		
		checkpoint_label.text = "CHECKPOINT"
		Global.target_spawn_name = "nie spawn"
		show_checkpoint_animation()

		was_activated = true 


func show_checkpoint_animation() -> void:
	if not checkpoint_label:
		return
		
	# Zamykamy resztę syfu na ekranie
	Global.clear_ui.emit(self)
	
	checkpoint_label.visible = true
	checkpoint_label.modulate.a = 0
	
	# Zmieniona inicjalizacja tweena, żeby korzystał ze zmiennej na górze
	if ui_tween: ui_tween.kill()
	ui_tween = create_tween()
	
	# Pojawianie się (0.4s)
	ui_tween.tween_property(checkpoint_label, "modulate:a", 1.0, 0.4)
	# Czekanie (1.5s)
	ui_tween.tween_interval(1.5)
	# Znikanie (0.6s)
	ui_tween.tween_property(checkpoint_label, "modulate:a", 0.0, 0.6)
	ui_tween.tween_callback(func(): checkpoint_label.visible = false)
