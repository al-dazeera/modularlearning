extends Area2D
var o=[]

func _ready():
	pass
	
func _process(delta):
	position = get_global_mouse_position()
	var count = len(get_overlapping_bodies())
	if (count == 0):
		pass
	elif (count == 1):
		if get_overlapping_bodies()[0].can_drag and get_overlapping_bodies()[0] is KinematicBody2D:
			if get_overlapping_bodies()[0]!=null:
				get_overlapping_bodies()[0].chosen()
				if (Input.is_action_just_pressed("mouse_click")):
					get_parent().push_paper_to_top(get_overlapping_bodies()[0])

	else:
		if get_overlapping_bodies()[0] is KinematicBody2D:
			var max_index = -15
			var top_paper = null
			for b in get_overlapping_bodies():
				if b!=null:
					if (b.z_index > max_index):
						max_index = b.z_index
						top_paper = b
				
			top_paper.chosen()
			for b in get_overlapping_bodies():
				if b!=null:
					if b != top_paper:
						b.chosen = false
			if (Input.is_action_just_pressed("mouse_click")):
				
				if top_paper.can_drag:
					get_parent().push_paper_to_top(top_paper)



