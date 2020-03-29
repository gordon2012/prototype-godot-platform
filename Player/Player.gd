extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -550
const BOUNCE_VELOCITY = -400

var motion = Vector2()

onready var bounce_raycasts = $BounceRaycasts

# health bar
const MAX_HEALTH = 16
const HEART_ROW_SIZE = 8
const HEART_OFFSET = 56
onready var hearts = $Score/UI/hearts

func _ready():
	$FadeCanvasLayer/FadeColorRect.show()
	if Global.teleport_target != null:
		teleport_to(get_tree().get_root().find_node(Global.teleport_target, true, false).position)
		Global.teleport_target = null
	else:
		get_node("AnimationPlayer").play("_SETUP")
	updateScore()
	
	# health bar
	for i in MAX_HEALTH:
		var new_heart = Sprite.new()
		new_heart.texture = hearts.texture
		new_heart.hframes = hearts.hframes
		hearts.add_child(new_heart)

func _physics_process(delta):
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

	_check_bounce(delta)

	motion = move_and_slide(motion, UP)
	
	# health bar (maybe process instead of physics?)
	for heart in hearts.get_children():
		var index = heart.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		
		heart.position = Vector2(x, y)
		# heart.position = Vector2(x + hearts.position.x, y + hearts.position.y)
		# heart.position = Vector2(x + 100, y + 20)
		
		var player_health = 4.25
		#
		var last_heart = floor(player_health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (player_health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4

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

func _check_bounce(delta):
	if motion.y > 0:
		for raycast in bounce_raycasts.get_children():
			raycast.cast_to = Vector2.DOWN * motion * delta + Vector2.DOWN
			raycast.force_raycast_update()
			if raycast.is_colliding() && raycast.get_collision_normal() == Vector2.UP:
				motion.y = (raycast.get_collision_point() - raycast.global_position - Vector2.DOWN).y / delta
				raycast.get_collider().entity.call_deferred("be_bounced_upon", self)
				break

func bounce(bounce_velocity = BOUNCE_VELOCITY):
	motion.y = bounce_velocity

func updateScore():
	get_node("Score/UI/Base/ScoreLabel").text = "SCORE: " + str(Global.score)
