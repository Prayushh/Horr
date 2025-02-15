extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		$".".show()
		get_tree().paused = true
		if Input.is_action_just_pressed("pause"):
			$".".hide()
			get_tree().paused = false
