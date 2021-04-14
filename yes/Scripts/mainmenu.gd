extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_exit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
