#Player Movement
extends KinematicBody2D

const UP = Vector2(0, -1)
#this tells is_on_floor which direction is up, neg numbers on the y axis go up.
const ACCEL = 25
const GRAVITY = 10
const MAX_SPEED = 160
const JUMP_HEIGHT = -275
const WATER_BOLT = preload("res://WaterBolt.tscn")

var motion = Vector2()
var is_attacking = false

func _physics_process(delta):
	
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		if is_attacking == false:
			motion.x = min(motion.x + ACCEL, MAX_SPEED)
			#Basically takes the smaller of the 2 values, if left/right motion + acceleration 
			#is more than the max speed then it will just take the max speed value as left/right motion.
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Walk")
		
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		
	elif Input.is_action_pressed("ui_left"):
		if is_attacking == false:
			motion.x = max(motion.x - ACCEL, -MAX_SPEED)
			#same thing here, only it takes the max value
			#both of these are for smooth movement
			$AnimatedSprite.flip_h = true
			#if the sprite is flipped horizontally
			$AnimatedSprite.play("Walk")
		
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		
	else:
		if is_attacking == false:
			$AnimatedSprite.play("Idle") # if we're not moving, we're idle
			friction = true
		
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		is_attacking = true
		$AnimatedSprite.play("Spell")
		var waterbolt = WATER_BOLT.instance()
		if sign($Position2D.position.x) == 1:
			waterbolt.set_waterbolt_direction(1)
		else:
			waterbolt.set_waterbolt_direction(-1)
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
		if is_attacking == false:
			if motion.y < 0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Fall")
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.01) 
			
	
	motion = move_and_slide(motion, UP)
	#executes the motion commands and slides the character accordingly
	pass

func _on_VisibilityNotifier2D_screen_exited():
	pass

func _on_AnimatedSprite_animation_finished():
	is_attacking = false