extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -550

var motion = Vector2()

func _physics_process(_delta):
	motion.y+= GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = 200
		$Sprite.flip_h = false
		$Sprite.play("Walk")
	elif Input.is_action_pressed("ui_left"):
		motion.x = -200
		$Sprite.flip_h = true
		$Sprite.play("Walk")
	else:
		motion.x = 0
		$Sprite.play("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			motion.y = JUMP_HEIGHT
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")

	motion = move_and_slide(motion, UP)
	
func teleport_to(target):
	print("Teleporting")
	position = target
