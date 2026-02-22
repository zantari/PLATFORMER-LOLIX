extends Area2D

const fireball_scene: PackedScene = preload("res://scenes/fire_ball_dol.tscn")
@onready var timer = $ShootTimer 
@onready var shoot_sound = $ShootSound # <--- Dodana referencja do dźwięku
@export var kierunek: int = 1 # 1 = dół, -1 = góra
@export var czyWidoczne: bool = true
@onready var notifier = $VisibleNotifer # Referencja do notifiera

func _ready() -> void:
	if !czyWidoczne:
		$Sprite2D.visible = false

func _on_shoot_timer_timeout() -> void:
	if not fireball_scene:
		return
		
	var bullet = fireball_scene.instantiate()
	bullet.global_position = global_position + Vector2(0, 20 * kierunek)
	get_parent().add_child(bullet)

	# --- Odtwarzanie dźwięku TYLKO gdy na ekranie ---
	if shoot_sound and notifier.is_on_screen():
		shoot_sound.play()
	# -----------------------------------------------

	if bullet.has_method("launch"):
		bullet.launch(kierunek)
