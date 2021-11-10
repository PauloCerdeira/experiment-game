extends Area2D

const PRE_NOTIFICATION = preload("res://Scenes/Notification.tscn")
var player = null

func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("down") and player:
		var notification = PRE_NOTIFICATION.instance()
		notification.text = "You got a key!"
		player.get_node("CanvasLayer").get_node("UI").add_child(notification)
		player.getItem(self)
		queue_free()

func _on_key_body_entered(body):
	if body.name == "Player":
		player = body

func _on_key_body_exited(body):
	if body.name == "Player":
		player = null
