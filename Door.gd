extends Area2D

export(NodePath) var target = null

var player_in_door



func _process(_delta):
	if Input.is_action_just_pressed("enter_door") and player_in_door == true:
		print("Player using Door")
		if target != null:
			get_tree().call_group("Player", "teleport_to", get_node(target).position)


func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		print("Player entered Door")
		player_in_door = true


func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		print("Player exited Door")
		player_in_door = false
