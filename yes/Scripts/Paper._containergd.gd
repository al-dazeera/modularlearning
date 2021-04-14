extends KinematicBody2D

var draggingDistance
var dir
var dragging
var newPosition = Vector2()

onready var parent_node=get_parent()
onready var parent=get_parent().get_parent()
var g_p
var d=280

var paper=preload("res://Scenes/Paper.tscn")
var paper_m=preload("res://Scenes/paper_math.tscn")
var math_node=preload("res://Scenes/math_node.tscn")

var mouse_in = false
var chosen = false
#custom vars
var max_speed=Vector2(100,100)
var speed=Vector2()
var paper_arr=[]
var can_drag=true

func timer_identifier(node,mathnode):
	var time
	match mathnode.m:
		0:
			if len(mathnode.add_list)>2:
				time=40
			else:
				time=35
		1:
			if len(mathnode.mult_list)>2:
				time=42
			else:
				time=34
		2:
			time=39
	node.wait_time=time

#-------
func init_math():
	var n
	for _i in range(5):
		var p=paper_m.instance()
		data.mtotal_grade+=p.points_wrth
		paper_arr.append(p)
		
	for paper in paper_arr:
		var m_inst=math_node.instance()
		m_inst.init()
		paper.add_child(m_inst)
		n=m_inst.num
		paper.val_corr=n
		paper.init_answers()
		paper.init_text("Find the Value of : " + m_inst.text)
		timer_identifier(paper.get_node("Timer"),paper.get_node("math_node"))
		
func init_not_math():
	for _i in range(5):
		paper_arr.append(paper.instance())
	check()

func _ready():
	$Tween.interpolate_property(self,"global_position",Vector2(500,-400),Vector2(500,300),1,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	$Tween.start()
#	for i in len(data.text_array):
#		if data.text_array[i]["is_taken"]:
#			print(data.text_array[i][1])

func check():
	for children in paper_arr:
		children.init_dict()
		data.nmtotal_grade+=children.points_wrth
#	for children in paper_arr:
#		for _children in paper_arr:
#			if children!=_children:
#				while children.held_ques==_children.held_ques:
#					_children.init_dict()
	for children in paper_arr:
		if children.held_ques:
			children.init_text(children.held_ques[1])
			children.init_answers()
	for children in paper_arr:
		while children.arr_incor[0].value==children.arr_incor[1].value:
			randomize()
			children.arr_incor[0].value=data.text_array[int(rand_range(0,len(data.text_array)))][0]
			children.arr_incor[0]._text()

#func _input(event):
#	g_p=self.global_position
#	if event is InputEventMouseButton:
#		if chosen and event.is_pressed() && mouse_in:
#			$AudioStreamPlayer2D.play()
#			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
#			dir = (get_viewport().get_mouse_position() - position).normalized()
#			dragging = true
#			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
#		else:
#			dragging = false
#			chosen = false
#
#	elif event is InputEventMouseMotion:
#		if dragging:
#			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
#func _physics_process(delta):
#
#	if dragging:
#		speed=lerp(speed,max_speed,0.1)
#		move_and_slide((newPosition - position) * speed)
#		if speed>Vector2.ZERO and (!dragging or dragging):
#			speed=Vector2.ZERO
#
#	else:
#		speed=lerp(speed,Vector2(0,0),0.01)
	#custom

	#-------

#func chosen():
#	chosen = true
#
#func mouse_entered():
#	mouse_in = true
#
#func mouse_exited():
#	mouse_in = false


func _on_Button2_pressed():
	if parent.can_switch and data.is_math:
		parent.get_node("Camera2D/shake").start(0.7,5,25,1)
	g_p=global_position
	$AudioStreamPlayer2D.stream=load("res://muscandfx/paper_crunch.wav")
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled",true)
	var x=Vector2(g_p.x-d,g_p.x+d)
	var y=Vector2(g_p.y-d,g_p.y+d)
	var off=10
	can_drag=false
	$Sprite.set_deferred("visible",false)
	$Label.set_deferred("visible",false)
	self.set_deferred("z_index",-100)
	$multiple_choice.set_deferred("visible",false)
	$Particles2D.set_deferred("emitting",true)
	parent.paper_stack.erase(self)
	parent.first=false
	for children in paper_arr:
		randomize()
		parent_node.add_child(children)
		parent_node.get_parent().add_paper(children)
		$Tween.interpolate_property(children,"global_rotation",children.global_rotation,rand_range(children.global_rotation-off,children.global_rotation+off),0.7,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		$Tween.interpolate_property(children,"scale",Vector2.ZERO,Vector2(0.5,0.5),0.4,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		$Tween.interpolate_property(children,"global_position",global_position,Vector2(rand_range(x.x,x.y),rand_range(y.x,y.y)),0.4,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
		$Tween.start()
	yield($AudioStreamPlayer2D,"finished")
	queue_free()
