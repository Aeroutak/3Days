extends Area2D

const SPEED = 275
var velocity = Vector2()
var direction = 1

func set_waterbolt_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	
	velocity.x = SPEED * delta * direction
	#Speed * time since last frame
	translate(velocity)
	#translates(moves) the area by velocity, established above
	$AnimatedSprite.play("Water Bolt")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_WaterBolt_body_entered(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
