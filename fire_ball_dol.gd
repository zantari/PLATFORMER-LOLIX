extends Area2D

var direction = 1 # 1 = DÓŁ, -1 = GÓRA
var speed := 200
var vignette_tween: Tween

func _ready() -> void:
	
	rotation_degrees = 90

func launch(dir: int):
	direction = dir
	# Jeśli dir to 1 (dół) -> 90 stopni
	# Jeśli dir to -1 (góra) -> -90 stopni
	rotation_degrees = 90 * direction

func _process(delta: float) -> void:

	position.y += speed * direction * delta



func animate_vignette(vignette: ColorRect):
	var mat = vignette.material
	if vignette_tween and vignette_tween.is_running():
		vignette_tween.kill()
	vignette_tween = create_tween()
	mat.set_shader_parameter("vignette_color", Color(0.7, 0, 0, 1.0))
	mat.set_shader_parameter("outer_radius", 1.5)
	vignette_tween.parallel().tween_property(mat, "shader_parameter/vignette_color", Color(0, 0, 0, 1.0), 0.5)
	vignette_tween.parallel().tween_property(mat, "shader_parameter/outer_radius", 1.2, 0.5)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("get_damage"):
			body.get_damage(100)
		queue_free()
	else:
		queue_free()
