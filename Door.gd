extends Area2D

# Teleport for same scene
export(NodePath) var inner_target = null

# Teleport for external scene
export(String, FILE, "*.tscn") var outer_world = null
export(String) var outer_target = null

var player_in_door

func _ready():
	$Popup.hide()

func _process(_delta):
	if Input.is_action_just_pressed("enter_door") and player_in_door == true:
		if inner_target != null:
			get_tree().call_group("Player", "teleport_to", get_node(inner_target).position)
		elif outer_world != null and outer_target != null:
			Global.teleport_target = outer_target
			get_tree().change_scene(outer_world)

func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		player_in_door = true
		$Popup.show()

func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		player_in_door = false
		$Popup.hide()
