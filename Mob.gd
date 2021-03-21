extends RigidBody2D

# Value between 0 and 1 which specifies the strong level of the mob.
# A greater value means greater speed and angular velocity.
export (float) var hardness = 0
# Minimum & maxiumum linear speeds
export (float) var min_velocity = 100
export (float) var max_velocity = 400
# Randomness for linear speed
export (float) var velocity_var = 50

# Minimum and maximum angular velocity
export (float) var max_angular_velocity = 0
export (float) var min_angular_velocity = 50
# Randomness for angular velocity
export (float) var angular_velocity_var = 10

# How frequent the angular velocity changes the direction (clockwise & anti-clockwise) in a zig-zag fashion.
export (float) var min_waves_frequency = 0.5
export (float) var max_waves_frequency = 1.5


var current_speed



# Called when the node enters the scene tree for the first time.
func _ready():
	var animations = $AnimatedSprite2D.frames.get_animation_names()
	var animation = animations[randi() % len(animations)]
	$AnimatedSprite2D.animation = animation
	
	
	current_speed = lerp(min_velocity, max_velocity, hardness)
	current_speed += rand_range(-velocity_var, velocity_var)
	current_speed = clamp(current_speed, min_velocity, max_velocity)
	linear_velocity = Vector2(current_speed, 0).rotated(rotation)

	var angular_velocity = lerp(min_angular_velocity, max_angular_velocity, hardness)
	angular_velocity += rand_range(-angular_velocity_var, angular_velocity_var)
	angular_velocity = clamp(angular_velocity, min_angular_velocity, max_angular_velocity)
	angular_velocity = deg2rad(angular_velocity)
	var waves_frequency = rand_range(min_waves_frequency, max_waves_frequency)
	$AngularTween.interpolate_property(self, "angular_velocity", -angular_velocity, angular_velocity, 1/waves_frequency, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$AngularTweenBack.interpolate_property(self, "angular_velocity", angular_velocity, -angular_velocity, 1/waves_frequency, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$AngularTween.start()
	$AngularTweenBack.start()
	$AngularTweenBack.stop_all()


func _process(_delta):
	linear_velocity = Vector2(current_speed, 0).rotated(rotation)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_angular_tween_completed(_object, _key):
	$AngularTween.stop_all()
	$AngularTweenBack.reset_all()
	$AngularTweenBack.resume_all()
	

func _on_angular_tween_back_completed(_object, _key):
	$AngularTweenBack.stop_all()
	$AngularTween.reset_all()
	$AngularTween.resume_all()

