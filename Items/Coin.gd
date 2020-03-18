extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var player = get_tree().get_root().find_node("Player", true, false)

func _on_body_entered(body):
	anim_player.play("fade_out")
	Global.addScore(1)
	player.updateScore()
