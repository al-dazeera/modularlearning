extends KinematicBody2D

var draggingDistance
var dir
var dragging
var newPosition = Vector2()

var mouse_in = false
var chosen = false
#custom vars
var max_speed=Vector2(100,100)
var speed=Vector2()
var paper_val
	#text crap
var held_ques:Dictionary
var btn_corr
var is_questionnaire=true

var arr_incor: Array
var points_wrth=2
var was_dragged=false
var can_drag=true
#-------
func paper_set(val1,val2,text,per_):
	$multiple_choice/Button2.text="  CONTINUE  "
	$Label.text="Score is "+String(val1)+" / "+String(val2)+"  Percentage: "+String(per_)+"%, " +text
func remove_buttons():
	$multiple_choice/Button.queue_free()
	$multiple_choice/Button3.queue_free()
func init_text(text):
	$Label.text=String(text)
	
func init_dict():
	randomize()
	var num=int(rand_range(0,len(data.text_array)))
	while data.text_array[num]["is_taken"]:
		randomize()
		num=int(rand_range(0,len(data.text_array)))
	held_ques=data.text_array[num]
	data.text_array[num]["is_taken"]=true

func init_answers():
	var text
	randomize()
	btn_corr=int(rand_range(0,$multiple_choice.get_child_count()))
	$multiple_choice.get_child(btn_corr).value=held_ques[0]
	for children in $multiple_choice.get_children():
		if !children.value:
			arr_incor.append(children)
			text=data.text_array[int(rand_range(0,len(data.text_array)))][0]
			while text==held_ques[0]:
				randomize()
				text=data.text_array[int(rand_range(0,len(data.text_array)))][0]
			children.value=text
		children._text()

func check_answers():
	if is_questionnaire:
		if paper_val==held_ques[0]:
			data.nmplayer_grade+=points_wrth

func _input(event):
	if can_drag:
		if event is InputEventMouseButton:
			if chosen and event.is_pressed() && mouse_in:
				$AudioStreamPlayer2D.play()
				if self.global_rotation!=0:
					$Tween.interpolate_property(self,"scale",scale,Vector2(1,1),0.4,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
					$Tween.interpolate_property(self,"global_rotation",global_rotation,0,0.4,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
					$Tween.start()
				draggingDistance = position.distance_to(get_viewport().get_mouse_position())
				dir = (get_viewport().get_mouse_position() - position).normalized()
				dragging = true
				newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
				was_dragged=true
			else:
				dragging = false
				chosen = false
				
		elif event is InputEventMouseMotion:
			if dragging:
				newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
func _physics_process(delta):
	if dragging:
		speed=lerp(speed,max_speed,0.1)
		move_and_slide((newPosition - position) * speed)
		if speed>Vector2.ZERO and (!dragging or dragging):
			speed=Vector2.ZERO
		
	else:
		speed=lerp(speed,Vector2(0,0),0.01)
	#custom

	#-------

func chosen():
	chosen = true
	
func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false



#i dont know if there are any other solutions that will not cause a crash other than this
#the cause is that if there is one toggled button, and you double click another button, it crashes
#please forgive if this is an unprofessional way to do code
func _on_Button3_toggled(button_pressed):
	if button_pressed:
		paper_val=get_node("multiple_choice/Button3").value
		if get_node("multiple_choice/Button2").pressed:
			get_node("multiple_choice/Button2").pressed=false
		if get_node("multiple_choice/Button").pressed:
			get_node("multiple_choice/Button").pressed=false
	elif !button_pressed and (!get_node("multiple_choice/Button2").pressed and !get_node("multiple_choice/Button").pressed):
		paper_val=null
func _on_Button2_toggled(button_pressed):
	
	if $multiple_choice.get_child_count()>1:
		if button_pressed:
			paper_val=get_node("multiple_choice/Button2").value
			if get_node("multiple_choice/Button").pressed:
				get_node("multiple_choice/Button").pressed=false
			if get_node("multiple_choice/Button3").pressed:
				get_node("multiple_choice/Button3").pressed=false
		elif !button_pressed and (!get_node("multiple_choice/Button3").pressed and !get_node("multiple_choice/Button").pressed):
			paper_val=null
	if !is_questionnaire:
		if data.passed:
			if !data.not_math_finished and !data.is_math:
				data.not_math_finished=true
			if data.is_math:
				data.all_finish=true
			if !data.is_math:
				data.is_math=true
			data.unblur(get_parent().get_parent().get_node("CanvasLayer/ColorRect"))
			get_parent().get_parent().can_wobble=false
			get_parent().get_parent().get_node("CanvasLayer/Node2D/comenter").start()
			data.passed=false
		else:
			data.reset()
			data.resetted=true
			for num in range(len(data.text_array)):
				data.text_array[num]["is_taken"]=false
			get_parent().get_parent().module()
		can_drag=false
		get_parent().get_parent().paper_stack.erase(self)
		$CollisionShape2D.set_deferred("disabled",true)
		$Tween.interpolate_property(self,"global_rotation",global_rotation,rand_range(-10,10),0.7,Tween.TRANS_CIRC,Tween.EASE_IN_OUT)
		$Tween.interpolate_property(self,"scale",scale,Vector2.ZERO,0.7,Tween.TRANS_CIRC,Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		queue_free()
func _on_Button_toggled(button_pressed):
	if button_pressed:
		paper_val=get_node("multiple_choice/Button").value
		if get_node("multiple_choice/Button2").pressed:
			get_node("multiple_choice/Button2").pressed=false
		if get_node("multiple_choice/Button3").pressed:
			get_node("multiple_choice/Button3").pressed=false
	elif !button_pressed and (!get_node("multiple_choice/Button3").pressed and !get_node("multiple_choice/Button2").pressed):
		paper_val=null


func _on_VisibilityNotifier2D_screen_exited():
	$Tween.interpolate_property(self,"global_position",self.global_position,Vector2(500,300),0.6,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Tween.start()
