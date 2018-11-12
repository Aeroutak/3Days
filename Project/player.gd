#Player Movement
extends KinematicBody2D

const UP = Vector2(0, -1)
#this tells is_on_floor which direction is up, neg numbers on the y axis go up.
const ACCEL = 25
const GRAVITY = 10
const MAX_SPEED = 160
const JUMP_HEIGHT = -275

const WATER_BOLT = preload("WaterBolt.tscn")

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCEL, MAX_SPEED)
		#Basically takes the smaller of the 2 values, if left/right motion + acceleration 
		#is more than the max speed then it will just take the max speed value as left/right motion.
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
		
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCEL, -MAX_SPEED)
		#same thing here, only it takes the max value
		#both of these are for smooth movement
		$AnimatedSprite.flip_h = true
		#if the sprite is flipped horizontally
		$AnimatedSprite.play("Walk")
		
	else:
		$AnimatedSprite.play("Idle") # if we're not moving, we're idle
		friction = true
		
	if Input.is_action_just_pressed("ui_focus_next"):
		var waterbolt = WATER_BOLT.instance()
		get_parent().add_child(waterbolt)
		waterbolt.position = $Position2D.global_position

	
	if is_on_floor():
		
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.1) #Linear interpolation
			#1st num, where are we coming from?
			#2nd num, where are we going to?
			#3rd (between 0 & 1) percentage we slow for each frame, 0.2 = 20%
			
	else: #if we're not on the floor, we're in the air
		if motion.y < 0:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("Fall")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.01) 
			
	
	motion = move_and_slide(motion, UP)
	#executes the motion commands and slides the character accordingly
	pass