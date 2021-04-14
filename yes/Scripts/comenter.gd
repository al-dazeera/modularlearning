extends Sprite
var di_cheems=["Hemmloo, i am pRomfessor cheems, bemcaause ofm vimrus, wem teamchers gimve momdules",
"ifm youm finishm momdules, dragm the pamper inm the sumbmissiom pamnel",
"ifm youm hhamve a smcore lomwer tahmn 60%, youllm hamve to starmt ovmer agaimn",
"Samem gomes if youm toom much stressmm",
"GOOmD LummcK!!!1111!!!"]
var di_doge=["Greetings player, My name is Professor Doge, and im your math teacher",
"The rules of the modules are still the same but mine has a timer",
"If the timer goes out, the paper will implode and does not add a score even if the answer is correct. You can use calculators if you want",
"You can do it king."]

var congrats=["Congratulations King, you have now graduated from Stupid University.",
"Professor Cheems can't attend because he had a seizure",
"You have made it this far despite the hardships of school",
"Even if you think school is hard, you're still on your training wheels",
"School is just a training ground for children to realize the hardships of life",
"Anyways, you are now valedictorian because you are the only one enrolled in this institution.",
"Good bye and have a good day"]
func start():
	$Tween.interpolate_property(self,"global_position",global_position,Vector2(100,global_position.y),1.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
	$Tween.start()
	if !data.is_math:
		self.texture=load("res://Assets/chems.png")
	if data.is_math:
		self.texture=load("res://Assets/doge.png")
	if data.all_finish:
		self.texture=load("res://Assets/doge.png")
	yield($Tween,"tween_all_completed")
	var dialogue=load("res://Scenes/dialogue.tscn").instance()
	if !data.is_math:
		dialogue.messages=di_cheems
	if data.is_math:
		dialogue.messages=di_doge
	if data.all_finish:
		dialogue.messages=congrats
	add_child(dialogue)

func stop():
	$Tween.interpolate_property(self,"global_position",global_position,Vector2(-100,global_position.y),1.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
	$Tween.start()
	if !data.all_finish:
		get_parent().get_parent().get_parent().start()
	
	data.resetted=false
