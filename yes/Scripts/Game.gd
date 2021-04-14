extends Node2D
var can_wobble=false
var paper_stack  =[]
var paper_passed =[]
var per
var i=0
var paper_scene = preload("res://Scenes/Paper.tscn")
var paper_container = preload("res://Scenes/Paper_container.tscn")
var pc_inst
var finished=false
var first=true
var o=[]
var is_math=false
var can_switch=true
var can_module=false

var intensity=10
var frequency=3
# Called when the node enters the scene tree for the first time.
func play_audio(path):
	if path=="res://muscandfx/not_fun.wav":
		$AudioStreamPlayer2D.volume_db=-1
	$AudioStreamPlayer2D.stream=load(path)
	$AudioStreamPlayer2D.playing=true
func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	$CanvasLayer/Node2D/comenter.start()
func start():
	module()
func module():
	if data.resetted:
		if data.is_math:
			i=5
		else:
			i=0
		data.resetted=false
	i+=1
	pc_inst=paper_container.instance()
	if !data.is_math:
		pc_inst.init_not_math()
	else:
		pc_inst.init_math()
	pc_inst.get_node("Label").text="Module "+String(i)
	$Node.add_child(pc_inst)

			

func add_paper(paper):
	if paper.can_drag:
		paper_stack.append(paper)
		var count = 0

		for p in paper_stack:
			if p!=null:
				p.z_index = count
				count += 1
			else:
				paper_stack.erase(p)
func test_if_null():
	for paper in paper_stack:
		if paper==null:
			return true
		else:
			return false


func push_paper_to_top(paper):
	if paper.can_drag:
		if paper!=null:
			paper_stack.erase(paper)
			add_paper(paper)
		else:
			return

func results():
	var paper = paper_scene.instance()
	paper.is_questionnaire=false
	var ps
	var text
	var ts
	if !data.is_math:
		ps=data.nmplayer_grade
		ts=data.nmtotal_grade
	else:
		ps=data.mplayer_grade
		ts=data.mtotal_grade
	per=round((float(ps)/float(ts))*100)
	if per<60:
		text="YOU FAIL"
		data.passed=false
	else:
		text="YOU PASSED"
		data.passed=true
	paper.remove_buttons()
	paper.paper_set(ps,ts,text,per)
	$Node.add_child(paper)
	$Tween.interpolate_property(paper,"global_position",Vector2(500,-300),Vector2(500,300),1,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
	$Tween.start()
	add_paper(paper)
	
func wobble():
	$Camera2D/shake.start(1,frequency,intensity)

func check_if_no():
	if len(paper_stack)<1 and can_module:
		if !data.not_math_finished:
			if i<5:
				module()
			else:
				results()
				data.not_math_finished=true
		elif data.not_math_finished:
			if data.stress<7:
				if i<9:
					module()
				else:
					results()

func body_free():
	yield(get_tree().create_timer(0.01),"timeout")
	if data.stress<7:
		if $Node.get_child_count()<1:
			if i<9:
				module()
			else:
				results()
func _process(delta):
	for body in $Panel/Submission.get_overlapping_bodies():
		if !body.has_method("init_math") and body.was_dragged and body.is_questionnaire and Input.is_action_just_released("mouse_click"):
			can_module=true
			body.can_drag=false
			body.get_node("AudioStreamPlayer2D").stream=load("res://muscandfx/paper_crunch.wav")
			body.get_node("AudioStreamPlayer2D").play()
			if body.has_method("destroy"):
				body.destroying=true
			body.get_node("CollisionShape2D").set_deferred("disabled",true)
			paper_stack.erase(body)
			body.check_answers()
			$Tween.interpolate_property(body,"scale",body.scale,Vector2(0,0),0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
			$Tween.interpolate_property(body,"rotation",body.rotation,rand_range(-9,9),0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
			$Tween.start()
			yield(body.get_node("AudioStreamPlayer2D"),"finished")
			body.queue_free()
			check_if_no()
			can_module=false
func _on_Submission_body_entered(body):
	randomize()
	if body.name!="Paper_container":
		$Tween.interpolate_property($Panel,"modulate",$Panel.modulate,Color(1,1,1,1),0.15,Tween.TRANS_SINE,Tween.EASE_OUT_IN)
		$Tween.start()

func _on_Submission_body_exited(_body):
	$Tween.interpolate_property($Panel,"modulate",$Panel.modulate,Color(1,1,1,0.38),0.15,Tween.TRANS_SINE,Tween.EASE_OUT_IN)
	$Tween.start()


func _on_Timer_timeout():
	if can_wobble:
		wobble()


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
