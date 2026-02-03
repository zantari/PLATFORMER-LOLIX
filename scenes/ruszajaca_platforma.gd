extends AnimatableBody2D

func _process(delta: float) -> void:
	print(position)

func _on_activator_body_entered(body: Node2D) -> void:
	print("test")
	if body is Player:
		print("aktywuje sie")
		if $AnimationPlayer:
			$AnimationPlayer.play("position")
		else:
			print("RUSZAJACA PLATFORMA NIE MA ANIMATIONPLAYERA")
