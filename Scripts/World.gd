extends Node2D

const PRE_LEVEL_FINISHED = preload("res://Scenes/LevelFinished.tscn")

func _ready():
	pass

func levelFinished():
	var level_finished = PRE_LEVEL_FINISHED.instance()
	level_finished.currentLevel = -1
	get_node("stage_test/Player/CanvasLayer/UI").add_child(level_finished)
