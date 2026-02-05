extends StaticBody2D

@export var shake_power: float = 2.0 
@export var destroy_time: float = 1.5
@export var respawn_time: float = 5.0 # Czas na powrót

var is_triggered = false
var original_pos: Vector2 # Zapiszemy to sobie na starcie

func _ready():
	original_pos = position # Zapamiętaj gdzie stał

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_triggered:
		is_triggered = true 
		start_crumbling()

func start_crumbling() -> void:
	var time_passed = 0.0
	
	while time_passed < destroy_time:
		var offset = Vector2(randf_range(-shake_power, shake_power), randf_range(-shake_power, shake_power))
		position = original_pos + offset
		
		await get_tree().create_timer(0.05).timeout
		time_passed += 0.05
	
	# 1. Wracamy na miejsce
	position = original_pos
	
	# 2. Ukrywamy dziada i wyłączamy kolizję (ważne: set_deferred, żeby silnik nie świrował)
	hide() 
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$"kolizja dochodzenia".set_deferred("disabled", true)
	
	# 3. Czekamy 5 sekund (lub ile tam wpiszesz w respawn_time)
	await get_tree().create_timer(respawn_time).timeout
	
	# 4. Przywracamy wszystko
	show()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$"kolizja dochodzenia".set_deferred("disabled", false)
	is_triggered = false
