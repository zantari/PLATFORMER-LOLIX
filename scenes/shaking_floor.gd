extends StaticBody2D

@export var shake_power: float = 1.5 
@export var destroy_time: float = 1.5
@export var respawn_time: float = 5.0

var is_triggered = false
@onready var tilemap = $Area2D/TileMapLayer 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_triggered:
		is_triggered = true 
		start_crumbling()

func start_crumbling() -> void:
	var time_passed = 0.0
	var original_tilemap_pos = tilemap.position # 
	
	while time_passed < destroy_time:
		var offset = Vector2(randf_range(-shake_power, shake_power), randf_range(-shake_power, shake_power))
		tilemap.position = original_tilemap_pos + offset
		
		await get_tree().create_timer(0.05).timeout
		time_passed += 0.05
	

	tilemap.position = original_tilemap_pos
	

	hide() 
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$"kolizja dochodzenia".set_deferred("disabled", true)
	

	await get_tree().create_timer(respawn_time).timeout
	

	show()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$"kolizja dochodzenia".set_deferred("disabled", false)
	is_triggered = false
