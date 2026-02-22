extends Node2D

const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	# 1. REFERENCJA DO GRACZA
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		player.can_use_shield = true
		
		# 2. USTAWIANIE POZYCJI (ROZWIĄZANIE TWOJEGO PROBLEMU)
		# Szukamy punktu o nazwie MenuStart (Marker2D), który postawiłeś na mapie
		var spawn_point = get_node_or_null("MenuStart")
		if spawn_point:
			player.global_position = spawn_point.global_position
		else:
			# Jeśli nie ma punktu MenuStart, używamy współrzędnych z Global
			player.global_position = Global.spawn_position

	# --- RESZTA TWOJEJ LOGIKI ---
	get_tree().get_first_node_in_group("diamondLabel").maxDiamenty = 5
	Global.temporary_diamonds = 0 
	Global.currentScene = "level2"
	
	get_tree().get_first_node_in_group("diamondLabel").wyswietlijDiamenty()
	get_tree().call_group("diamondLabel", "pokazLevel")

func _on_player_shoot(pos, facing_right) -> void:
	var bullet = bullet_scene.instantiate()
	var direction = 1 if facing_right else -1
	bullet.direction = direction
	$Bullets.add_child(bullet)
	bullet.position = pos + Vector2(14 * direction, 5)
