extends Control


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	

func _on_StartButton_pressed():
	$StartButton.hide()
	$"../Player".on_game_start()

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartTimer_timeout():
	$StartButton.disabled = false
	show_message("Initialized")

func _process(delta):
	$Label.text = "Res: " + str(OS.get_window_size()) + "\n" + "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Pos: " + str(str($"../Player".translation)) + "\n" + "Velocity: " + str(str($"../Player".linear_velocity))
