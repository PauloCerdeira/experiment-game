extends KinematicBody2D

const PRE_CLOUD = preload("res://Scenes/jumpCloud.tscn")

var gravity = 1000

export var speed = 300
export var jumpForce = 650
export var wallSlideDivider = 6

var isAlive = true

var velocity = Vector2.ZERO
var canJump = false
var canDoubleJump = false
var isOnWall = false
var canWalljump = false
var isWalljumping = false
var walljumpDir = 0
var isDucking = false

var items = []


func _ready():
	pass

func _process(delta):
	if isAlive:
		handleInput(delta)
		handleSprites()
	else:
		handleDeath()


#CUSTOM FUNCTIONS
func handleInput(delta):
	velocity.y += gravity * delta
	velocity.x =  ((Input.get_action_strength("right") - Input.get_action_strength("left")) * speed)
	
	if isOnWall and (Input.get_action_strength("right") - Input.get_action_strength("left")) != 0 and !canJump:
		canDoubleJump = true
		canWalljump = true
		if velocity.y > 0:
			velocity.y =  gravity / wallSlideDivider
	else:
		canWalljump = false
	
	if Input.is_action_just_pressed("jump"):
		if canJump:
			velocity.y = -jumpForce
		elif canDoubleJump and !canWalljump:
			createJumpCloud()
			velocity.y = -jumpForce
			canDoubleJump = false
		elif canWalljump:
			$Timers/Walljump.start()
			velocity.y = -jumpForce * 0.7
			isWalljumping = true
	if Input.is_action_pressed("down"):
		duck(true)
	else:
		duck(false)
		
	
	if isWalljumping:
		velocity.x = walljumpDir
		
	if Input.is_action_just_pressed("inventory"):
		inventory()
	
	velocity = move_and_slide(velocity)

func handleSprites():
	$AnimatedSprite.play("walk")
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("stand")
		
	if !canJump:
		$AnimatedSprite.play("jump")
		
	if isDucking and canJump:
		$AnimatedSprite.play("duck")
		$AnimatedSprite.offset.y = 13
		if velocity.x < 0 and canJump:
			$AnimationPlayer.play_backwards("duck_roll")
		elif velocity.x > 0 and canJump:
			$AnimationPlayer.play("duck_roll")
	else:
		$AnimatedSprite.offset.y = 0
	
	if canWalljump:
		$AnimatedSprite.play("wallSlide")

func handleDeath():
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func createJumpCloud():
	var cloud = PRE_CLOUD.instance()
	cloud.position = global_position
	get_parent().add_child(cloud)

func duck(willDuck):
	if willDuck:
		isDucking = true
		$CollisionShape2D.position.y = 16
		$CollisionShape2D.scale.y = 0.7
		$leftWallCheckArea/CollisionShape2D.position.y = 16
		$leftWallCheckArea/CollisionShape2D.scale.y = 0.7
		$rightWallCheckArea/CollisionShape2D.position.y = 16
		$rightWallCheckArea/CollisionShape2D.scale.y = 0.7
	else:
		isDucking = false
		$CollisionShape2D.position.y = 0
		$CollisionShape2D.scale.y = 1
		$leftWallCheckArea/CollisionShape2D.position.y = 0
		$leftWallCheckArea/CollisionShape2D.scale.y = 1
		$rightWallCheckArea/CollisionShape2D.position.y = 0
		$rightWallCheckArea/CollisionShape2D.scale.y = 1

func inventory(_trueOrFalse = null):
	if (_trueOrFalse != null):
		$CanvasLayer/UI/Inventory.visible = _trueOrFalse
	else:
		$CanvasLayer/UI/Inventory.visible = !$CanvasLayer/UI/Inventory.visible

func getItem(item):
	items.push_back(item)
	$CanvasLayer/UI/Inventory/ItemList.add_item(item.name, item.get_node("Sprite").texture, true)

func died():
	isAlive = false
	inventory(false)
	$AnimatedSprite.play("death")
	$AnimationPlayer.play("death")
	

#SIGNALS
func _on_groundCheckArea_body_entered(body):
	if body.name != "Player":
		canJump = true
		canDoubleJump = true


func _on_groundCheckArea_body_exited(body):
	if body.name != "Player":
		canJump = false
		


func _on_leftWallCheckArea_body_entered(body):
	if body.name != "Player":
		walljumpDir = speed
		isOnWall = true


func _on_leftWallCheckArea_body_exited(body):
	if body.name != "Player":
		isOnWall = false


func _on_rightWallCheckArea_body_entered(body):
	if body.name != "Player":
		walljumpDir = -speed
		isOnWall = true


func _on_rightWallCheckArea_body_exited(body):
	if body.name != "Player":
		isOnWall = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "duck_roll":
		$AnimationPlayer.stop()
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.offset.y = 0
	elif anim_name == "death":
		$AnimatedSprite.visible = false
		$CPUParticles2D.emitting = true
		$CanvasLayer/UI/restartLabel.visible = true


func _on_Walljump_timeout():
	isWalljumping = false
