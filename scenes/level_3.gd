extends Node2D

const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	get_tree().get_first_node_in_group("Player").can_use_shield = true
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


func _on_teleport_body_entered(body: Node2D) -> void:
	print("wyjebalo poza mape")
	body.global_position = Vector2(2518.0, 923.0)
