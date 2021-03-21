extends Node

export (PackedScene) var mob
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_process(false)
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	#for enemy in get_tree().get_nodes_in_group("enemies"):
	#	enemy.queue_free()
	get_tree().call_group("enemies", "queue_free")
	$Player.set_process(false)
	$HUD.show_game_over(score)
	$Music.stop()
	$GameoverSound.play()
	
	
	
func game_start():
	score = 0
	$StartTimer.start()
	$Player.start($StartPosition.position)
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")
	

	
func create_mob():
	var enemy = mob.instance()
	$Path2D/PathFollow2D.offset = randi()
	
	var position = $Path2D/PathFollow2D.position
	var direction = $Path2D/PathFollow2D.rotation + PI/2
	direction += rand_range(-PI/4,PI/4)
	
	enemy.position = position
	enemy.rotation = direction
	enemy.hardness = min(1, float(score)/180)
	$MobTimer.wait_time = lerp(2, 0.5, min(1, score/180))
	
	enemy.add_to_group("enemies")
	return enemy
	


func _on_StartTimer_timeout():
	$Player.set_process(true)
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD/ScoreLabel.show()
	$Music.play()
	

func _on_MobTimer_timeout():
	add_child(create_mob())

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_Player_hit():
	game_over()



