extends Node

#func _ready():
#	yield(get_tree().create_timer(0.01),"timeout")
#	for children in get_children():
#		children.init_dict()
#		children.go_to()
#		data.total_grade+=children.points_wrth
#	for children in get_children():
#		for _children in get_children():
#			if children!=_children:
#				while children.held_ques==_children.held_ques:
#					_children.init_dict()
#	for children in get_children():
#		if children.held_ques:
#			children.init_text(children.held_ques[1])
#			children.init_answers()
#		yield(get_tree().create_timer(0.01),"timeout")
#	for children in get_children():
#		while children.arr_incor[0].value==children.arr_incor[1].value:
#			randomize()
#			children.arr_incor[0].value=data.text_array[int(rand_range(0,len(data.text_array)))][0]
#			children.arr_incor[0]._text()
