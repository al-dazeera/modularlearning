extends Button

var value

func _text():
	self.get_child(0).text=String(value)
