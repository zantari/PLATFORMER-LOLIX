extends Area2D

@onready var checkpoint_label: Label = $CheckpointUI/CheckpointLabel
@export var is_starting_checkpoint: bool = false 
@onready var player = get_tree().get_first_node_in_group("Player")
var was_activated: bool = false 

var ZombieTexts: Array[String] = [
	"Aim for the head!",
	"They like brains",
	"Try press Q",
	"Can you use your shield?",
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
	"Not even close",
	"Nice try",
	"try to jump",
	"AVOID LAVA!!",
	"LMB/E - SHOOT, Q - SHIELD, WSAD - MOVEMENT, use that info"
	
]
func _ready() -> void:
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
	
	
	checkpoint_label.visible = true
	checkpoint_label.modulate.a = 0
	
	var tween = create_tween()
	# Pojawianie się (0.4s)
	tween.tween_property(checkpoint_label, "modulate:a", 1.0, 0.4)
	# Czekanie (1.5s)
	tween.tween_interval(1.5)
	# Znikanie (0.6s)
	tween.tween_property(checkpoint_label, "modulate:a", 0.0, 0.6)
	tween.tween_callback(func(): checkpoint_label.visible = false)
