extends Area2D

signal hit

export var speed = 400
var screen_size
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position


func _process(dt):
	var direction = Vector2(0, 0)
	
	#if Input.is_action_pressed("ui_left"):
	#	direction.x = -1
	#if Input.is_action_pressed("ui_right"):
	#	direction.x = 1
	#if Input.is_action_pressed("ui_up"):
	#	direction.y = -1
	#if Input.is_action_pressed("ui_down"):
	#	direction.y = 1
	
	if target.distance_to(position) > 10:
		direction = (target - position).normalized()

	
		
	if direction.length_squared() == 0 and $AnimatedSprite.playing:
		$AnimatedSprite.stop()
	else:
		$AnimatedSprite.play()
		
	if direction.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = direction.x < 0
		$AnimatedSprite.flip_v = false
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
		$AnimatedSprite.flip_h = false
		
	position += direction.normalized() * speed * dt
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_body_entered(_body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
