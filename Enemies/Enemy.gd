extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var direction = 1
var dead = false

func _physics_process(delta):
	if dead:
		return
	
	velocity.x = SPEED * direction * -1
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction *= -1
		$ray.position.x *= -1
		
	if $ray.is_colliding() == false:
		direction *= -1
		$ray.position.x *= -1

	if direction == 1:
		$sprite.flip_h = false
	else:
		$sprite.flip_h = true

func be_bounced_upon(bouncer):
	if bouncer.has_method("bounce") && !dead:
		bouncer.bounce()
		$sprite.play("die")
		dead = true

func _on_sprite_animation_finished():
	print("anim done")
	remove_child($CollisionShape2D)
	remove_child($BounceArea)
