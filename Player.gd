extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -550

var motion = Vector2()

func _ready():
	$FadeCanvasLayer/FadeColorRect.show()
	if Global.teleport_target != null:
		teleport_to(get_tree().get_root().find_node(Global.teleport_target, true, false).position)
		Global.teleport_target = null
	else:
		get_node("AnimationPlayer").play("_SETUP")

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

func fade_out():
	get_node("AnimationPlayer").play("FadeOut")

func fade_in():
	get_node("AnimationPlayer").play("FadeIn")

func teleport_to(target):
	if Global.teleport_target == null:
		fade_out()
		yield(get_node("AnimationPlayer"), "animation_finished")

	position = target
	fade_in()
