extends Area2D

@export var blood_color: Color = Color.GREEN
@onready var start_pos = global_position
var max_health: int = 5
var health := max_health
var direction_x := 1
var speed := 60
var vignette_tween: Tween
var is_dead := false # Flaga, by nie odpalać śmierci wiele razy

@export var DAMAGE: int = 40

# Referencje do dźwięków
@onready var dmg_sound = $DmgSound
@onready var death_sound = $DeathSound

func get_dmg(dmg, area):
	if is_dead: return
	
	health -= dmg # Najpierw odejmujemy zdrowie, żeby wiedzieć czy to śmiertelny cios
	
	if area.is_in_group("pocisk"):
		if health <= 0:
			# Jeśli ten strzał zabił, nie puszczamy dźwięku trafienia, tylko od razu śmierć
			die()
		else:
			# Jeśli przeciwnik jeszcze żyje, puszczamy odpowiedni dźwięk trafienia
			if dmg >= 5: # Headshot (ale nie zabił)
				area.shake_amount = 0.4
				death_sound.play()
			else: # Zwykłe trafienie
				if dmg == 3: area.shake_amount = 0.3
				dmg_sound.pitch_scale = randf_range(0.8, 1.1)
				dmg_sound.play()
		
	# Efekt wizualny (błysk)
	var tween = create_tween() 
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.1)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1)

func die():
	if is_dead: return
	is_dead = true
	
	# Zatrzymujemy postać i ukrywamy elementy wizualne
	speed = 0
	set_process(false) # Wyłączamy _process, żeby przestał się ruszać
	$CollisionShape2D.set_deferred("disabled", true) 
	$AnimatedSprite2D.visible = false 
	if has_node("HealthBar"): $HealthBar.visible = false
	
	# Dźwięk śmierci - teraz odpali się tylko raz
	if death_sound:
		death_sound.play()
		# Czekamy aż dźwięk się skończy przed usunięciem obiektu
		await death_sound.finished
	
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("pocisk"):
		get_dmg(1, area)
		area.queue_free()

func _on_head_shot_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("pocisk"):
		get_dmg(5, area) # Zadaje 5 obrażeń i odpala dźwięk headshota
		area.queue_free()
	
func _process(delta: float) -> void:
	if is_dead: return # Przestań się ruszać jeśli martwy
	
	update_health()
	position.x += speed * direction_x * delta

# Logika winiety i gracza pozostaje bez zmian
func _on_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.is_in_group("Player"):
		var player = body
		var is_shielded = player.isShieldOnFunc() if player.has_method("isShieldOnFunc") else false
		
		var vignette = get_tree().get_first_node_in_group("Vignette")
		if vignette:
			animate_vignette(vignette, is_shielded)
		
		if not is_shielded:
			if player.has_method("get_damage"):
				player.get_damage(DAMAGE)
				if player.health <= 0:
					Global.lastSlayer = "zombie"
		else:
			direction_x *= -1
			$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func animate_vignette(vignette: ColorRect, is_shielded: bool = false):
	var mat = vignette.material
	if vignette_tween and vignette_tween.is_running():
		vignette_tween.kill()
	vignette_tween = create_tween()
	
	if is_shielded:
		vignette_tween.parallel().tween_property(mat, "shader_parameter/vignette_color", Color(0, 0, 0, 1.0), 0.1)
		vignette_tween.parallel().tween_property(mat, "shader_parameter/outer_radius", 1.2, 0.1)
		return 

	mat.set_shader_parameter("vignette_color", Color(1.0, 0.417, 0.348, 1.0))
	mat.set_shader_parameter("outer_radius", 1.5)
	vignette_tween.parallel().tween_property(mat, "shader_parameter/vignette_color", Color(0, 0, 0, 1.0), 0.5)
	vignette_tween.parallel().tween_property(mat, "shader_parameter/outer_radius", 1.2, 0.5)

# Pozostałe funkcje (klify, ściany, pasek zdrowia)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		direction_x *= -1 
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_right_cliff_body_exited(body: Node2D) -> void:
	direction_x *= -1 
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_left_cliff_body_exited(body: Node2D) -> void:
	direction_x *= -1 
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func update_health():
	var healthbar = $HealthBar
	if healthbar:
		healthbar.max_value = max_health
		healthbar.value = health
		healthbar.visible = health < max_health and health > 0
		healthbar.position.x = -20 if direction_x < 0 else -14.0

func reset_position():
	is_dead = false
	global_position = start_pos
	health = max_health
	visible = true
	set_process(true)
	$CollisionShape2D.disabled = false
