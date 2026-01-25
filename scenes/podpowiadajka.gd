extends Area2D

var ui_tween: Tween


@onready var label = $CheckpointUI/CheckpointLabel
@onready var rect = $CheckpointUI/ColorRect
@onready var btn = $CheckpointUI/SKIP
@onready var sprite = $Sprite2D
@export var tresc:String = "WSAD/ARROWS: MOVEMENT\nE/LMB: SHOOT\nQ: SHIELD"

func _ready():

	label.visible = false
	rect.visible = false
	btn.visible = false
	label.modulate.a = 0
	rect.modulate.a = 0
	btn.modulate.a = 0
	

	var float_tween = create_tween().set_loops()
	float_tween.tween_property(sprite, "position:y", sprite.position.y - 10, 1.2).set_trans(Tween.TRANS_SINE)
	float_tween.tween_property(sprite, "position:y", sprite.position.y, 1.2).set_trans(Tween.TRANS_SINE)

func _on_body_entered(body: Node2D):
	if body is Player:

		set_deferred("monitoring", false)
		sprite.visible = false

		start_sequence()

func start_sequence():
	
	if ui_tween: ui_tween.kill()
	

	label.text = tresc
	label.visible = true
	rect.visible = true
	btn.visible = true
	
	
	ui_tween = create_tween()
	

	ui_tween.set_parallel(true)
	ui_tween.tween_property(label, "modulate:a", 1.0, 0.5)
	ui_tween.tween_property(rect, "modulate:a", 1.0, 0.5)
	ui_tween.tween_property(btn, "modulate:a", 1.0, 0.5)
	ui_tween.set_parallel(false)
	ui_tween.tween_interval(4.0)
	ui_tween.tween_property(label, "modulate:a", 0.0, 0.2)
	ui_tween.tween_callback(func(): label.text = "GOOD LUCK")
	ui_tween.tween_property(label, "modulate:a", 1.0, 0.2) 
	

	ui_tween.tween_interval(2.0)
	ui_tween.tween_callback(close_sequence)

func _on_skip_pressed():

	close_sequence()

func close_sequence():

	if ui_tween: ui_tween.kill()

	var close_tween = create_tween().set_parallel(true)
	close_tween.tween_property(label, "modulate:a", 0.0, 0.3)
	close_tween.tween_property(rect, "modulate:a", 0.0, 0.3)
	close_tween.tween_property(btn, "modulate:a", 0.0, 0.3)
	

	close_tween.chain().tween_callback(finish_closing_and_start_timer)

func finish_closing_and_start_timer():

	label.visible = false
	rect.visible = false
	btn.visible = false
	

	get_tree().create_timer(3.0).timeout.connect(respawn_checkpoint)

func respawn_checkpoint():

	sprite.visible = true
	set_deferred("monitoring", true)
