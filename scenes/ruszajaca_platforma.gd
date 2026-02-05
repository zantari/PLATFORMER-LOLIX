extends AnimatableBody2D

var _is_activated: bool = false # Nasz strażnik



func _on_activator_body_entered(body: Node2D) -> void:

	if body is Player and not _is_activated:
		print("aktywuje sie")
		_is_activated = true
		
		if $AnimationPlayer:
			$AnimationPlayer.play("position")
		else:
			print("RUSZAJACA PLATFORMA NIE MA ANIMATIONPLAYERA")
