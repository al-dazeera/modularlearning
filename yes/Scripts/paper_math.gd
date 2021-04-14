extends KinematicBody2D

signal free

var draggingDistance
var dir
var dragging
var can_des=true
var newPosition = Vector2()

var is_questionnaire=true
var mouse_in = false
var chosen = false
#custom vars
var max_speed=Vector2(100,100)
var speed=Vector2()
var paper_val
	#text crap
var held_ques:Dictionary
var btn_corr
var val_corr
var destroying=false
var arr_incor: Array
var points_wrth=2
var was_dragged=false
var can_drag=true
#-------
func go_to():
	randomize()
	var pos=Vector2(int(rand_range(200,600)),rand_range(300,400))
	self.global_position=pos
	
func init_text(text):
	$Label.text=String(text)

func init_answers():
	var arr=$multiple_choice.get_children()
	var text
	randomize()
	btn_corr=int(rand_range(0,$multiple_choice.get_child_count()))
	$multiple_choice.get_child(btn_corr).value=val_corr
	$multiple_choice.get_child(btn_corr)._text()
	for num in range(0,len(arr)):
		if !arr[num].value:
			arr_incor.append(arr[num])
	for num in len(arr_incor):
		text=get_node("math_node").list_w[num]
		arr_incor[num].value=text
		arr_incor[num]._text()

func check_answers():
	if paper_val==val_corr:
		data.mplayer_grade+=points_wrth

func _ready():
	connect("free",get_parent().get_parent(),"body_free")

func _input(event):
	if !data.stressed:
		if can_drag:
			if event is InputEventMouseButton:
				if chosen and event.is_pressed() && mouse_in:
					$AudioStreamPlayer2D.play()
					if self.global_rotation!=0:
						$Tween.interpolate_property(self,"global_rotation",global_rotation,0,0.4,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
						$Tween.interpolate_property(self,"scale",scale,Vector2(1,1),0.4,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
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
	if data.stressed and can_des:
		can_des=false
		destroy()
	var time_text="Time Left: "+str(stepify($Timer.time_left,0.1))
	$Label2.text=time_text
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
	if data.stress<8:
		if button_pressed:
			paper_val=get_node("multiple_choice/Button3").value
			if get_node("multiple_choice/Button2").pressed:
				get_node("multiple_choice/Button2").pressed=false
			if get_node("multiple_choice/Button").pressed:
				get_node("multiple_choice/Button").pressed=false
		elif !button_pressed and (!get_node("multiple_choice/Button2").pressed and !get_node("multiple_choice/Button").pressed):
			paper_val=null
func _on_Button2_toggled(button_pressed):
	if data.stress<8:
		if get_parent().get_child_count()!=1:
			if button_pressed:
				paper_val=get_node("multiple_choice/Button2").value
				if get_node("multiple_choice/Button").pressed:
					get_node("multiple_choice/Button").pressed=false
				if get_node("multiple_choice/Button3").pressed:
					get_node("multiple_choice/Button3").pressed=false
			elif !button_pressed and (!get_node("multiple_choice/Button3").pressed and !get_node("multiple_choice/Button").pressed):
				paper_val=null
func _on_Button_toggled(button_pressed):
	if data.stress<8:
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


func destroy():
	if !destroying:
		can_drag=false
		destroying=true
		var _int=get_parent().get_parent().intensity
		var fre=get_parent().get_parent().frequency
		data.stress+=1
		if data.stress>7:
			get_parent().get_parent().get_node("Label").start()
		data.blur(get_parent().get_parent().get_node("CanvasLayer/ColorRect"))
		if !get_parent().get_parent().can_wobble:
			get_parent().get_parent().can_wobble=true
		_int+=1.5
		fre+=1
		_int=clamp(_int,0,20)
		fre==clamp(fre,0,6)
		get_parent().get_parent().paper_stack.erase(self)
		
		get_parent().get_parent().get_node("Camera2D/shake").start(0.8,15,16,1)
		get_node("AudioStreamPlayer2D").stream=load("res://muscandfx/paper_crunch.wav")
		get_node("AudioStreamPlayer2D").play()
		
		
		$Tween.interpolate_property(self,"scale",scale,Vector2(0,0),0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		$Tween.interpolate_property(self,"rotation",rotation,rand_range(-9,9),0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
		$Tween.start()
		
		
		yield(get_tree().create_timer(1.5),"timeout")
		emit_signal("free")
		queue_free()
func _on_Timer_timeout():
	destroy()
