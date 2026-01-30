extends Area2D

const fireball_scene: PackedScene = preload("res://scenes/fire_ball_dol.tscn")
@onready var timer = $ShootTImer 
@export var kierunek: int = 1 # 1 = dół, -1 = góra

func _on_shoot_timer_timeout() -> void:
	
	if not fireball_scene:
		return
		
	var bullet = fireball_scene.instantiate()
	
	bullet.global_position = global_position + Vector2(0, 20 * kierunek)
	
	get_parent().add_child(bullet)

	if bullet.has_method("launch"):
		bullet.launch(kierunek)
	else:
		print("nie ma takiej metody")
