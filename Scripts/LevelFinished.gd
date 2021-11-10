extends Panel

var arrayLevels = [
	'res://Scenes/World.tscn'
]
var currentLevel = 0

func _ready():
	pass


func _on_Button_pressed():
	get_tree().change_scene(arrayLevels[currentLevel + 1])
