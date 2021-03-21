extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.

func show_message(message):
	$Message.text = message
	$Message.show()
	$MessageTimer.start()


func show_game_over(score):
	$ScoreLabel.hide()
	show_message("Game over!\nYour final\nscore is " + str(score))
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	$ScoreLabel.show()
	

func _on_StartButton_pressed():
	$StartButton.hide()
	$Message.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$Message.hide()
	
