extends Sprite


func _ready():
	pass

func _process(delta):
	position.y += delta

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
