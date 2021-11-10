extends Control
var text = ""
var cont = 0

func _ready():
	$Panel/Label.text = text
	$Tween.interpolate_property($Panel, "rect_position",
		$Panel.rect_position, Vector2($Panel.rect_position.x, $Panel.rect_position.y -50), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($Panel, "modulate",
		$Panel.modulate, Color(1,1,1,1), 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()



func _on_Tween_tween_completed(_object, _key):
	cont += 1
	if cont == 1:
		$Tween.stop_all()
		$Timer.start()
	else:
		queue_free()


func _on_Timer_timeout():
	$Tween.interpolate_property($Panel, "modulate",
		$Panel.modulate, Color(1,1,1,0), 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
