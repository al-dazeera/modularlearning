extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	self.text=String(data.player_grade)+" / "+String(data.total_grade)
