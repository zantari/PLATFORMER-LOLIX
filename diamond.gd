extends Area2D

@onready var start_y: float = position.y
var collected: bool = false

# Referencja do dźwięku
@onready var collect_sound = $CollectSound

func _ready() -> void:
	add_to_group("Collectibles")
	var my_path = str(get_path())
	if my_path in Global.permanent_collected_list:
		queue_free()
		return

func _process(_delta: float) -> void:
	if not collected:
		position.y = start_y + sin(Time.get_ticks_msec() / 300.0) * 10

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not collected:
		collect()

func collect():
	collected = true
	
	# ODTWARZANIE DŹWIĘKU
	if collect_sound:
		collect_sound.play()
	
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Wysyłamy do Globala informację o zebraniu
	Global.add_diamond(str(get_path()))
	
	# CZEKAMY NA KONIEC DŹWIĘKU ZANIM USUNIEMY OBIEKT
	# (Dzięki temu diament nie zaśmieca pamięci po zebraniu)
	if collect_sound:
		await collect_sound.finished
	
	queue_free()
