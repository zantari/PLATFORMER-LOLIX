extends MarginContainer




func animate_stats(target_diamonds: int):
	var label = $MarginContainer2/reszta # upewnij się, że ścieżka jest poprawna
	var tween = create_tween()
	
	# Animujemy liczbę od 0 do target_diamonds w czasie 1 sekundy
	tween.tween_method(func(value): 
		label.text = "DIAMONDS: " + str(value) + "/5", 
		0, target_diamonds, 1.0
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
