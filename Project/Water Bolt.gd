extends Area2D

const SPEED = 150
var velocity = Vector2()

func _physics_process(delta):
	
	velocity.x = SPEED * delta
	#Speed * time since last frame
	
	translate(velocity)
	#translates(moves) the area by velocity, establish above
	
	$AnimatedSprite.play("Water Bolt")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
