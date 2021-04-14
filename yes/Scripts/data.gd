extends Node

var nmplayer_grade=0
var nmtotal_grade=0

var mplayer_grade=0
var mtotal_grade=0
var stress=0
var alpha=-1
var stressed=false
var num_redness=0
var passed=false
var is_math=false
var resetted=false
var all_finish=false
var not_math_finished=false
var math_finished=false
func reset():
	if !is_math:
		nmplayer_grade=0
		nmtotal_grade=0
		not_math_finished=false
	else:
		mplayer_grade=0
		mtotal_grade=0
		math_finished=false

func blur(node):
	if num_redness<0.7:
		num_redness+=0.15
		num_redness=lerp(num_redness,num_redness+0.15,0.01)
		node.get_material().set_shader_param("color",Vector3(num_redness,0,0))
		if alpha<0:
			alpha+=0.15
			alpha=lerp(alpha,alpha+0.15,0.01)
			node.get_material().set_shader_param("alpha",alpha)

func unblur(node):
	num_redness=0
	alpha=-1
	node.get_material().set_shader_param("color",Vector3(0,0,0))
	node.get_material().set_shader_param("alpha",-1)
var text_array={
	0:{
		"is_taken":false,
		1:"Who is make facebooK?",
		0:"Mark Zuckerberg"
	},
	1:{
		"is_taken":false,
		1:"Philippines Good?",
		0:"Yes"
	},
	2:{
		
		"is_taken":false,

		1:"If I must go to school? Will you go to school?",
		0:"Yes"
	},
	3:{
		"is_taken":false,

		1:"Sleep in 12 am?",
		0:"No"
	},
	4:{
		"is_taken":false,

		1:"Gorilla is animal or mammal?",
		0:"mammal"
	},
	5:{
		"is_taken":false,

		1:"yakunitatanai, meaning in english?",
		0:"useless"
	},
	6:{
		"is_taken":false,

		1:"What do you do if you big fat butt?",
		0:"Wiggle wiggle"
	},
	7:{
		"is_taken":false,

		1:"Is math useful?",
		0:"Yes"
	},
	8:{
		"is_taken":false,

		1:"George Miller",
		0:"Filthy Frank"
	},
	9:{
		"is_taken":false,

		1:"Who made the blue aliens",
		0:"Robert Pyle"
	},
	10:{
		"is_taken":false,

		1:"What engine did valve use to makke half-life 2?",
		0:"Source"
	},
	11:{
		"is_taken":false,

		1:"Who is 1st president of USA?",
		0:"Gorg Washingmachine"
	},
	12:{
		"is_taken":false,

		1:"Thunderbolts and lightning, very very frightening",
		0:"Mama mia"
	},
	13:{
		"is_taken":false,

		1:"Press (-) to pay respects",
		0:"F"
	},
	14:{
		"is_taken":false,

		1:"Ugandan Chungus",
		0:"knuckles big"
	},
	15:{
		"is_taken":false,

		1:"This is made with?",
		0:"Godot"
	},
	16:{
		"is_taken":false,

		1:"Do i have to do this?",
		0:"Yes"
	},
	17:{
		"is_taken":false,

		1:"What is the color of my blood?",
		0:"Red"
	},
	18:{
		"is_taken":false,

		1:"What is the color of my Poop?",
		0:"Brown"
	},
	19:{
		"is_taken":false,

		1:"What is the finest in the world?",
		0:"German science"
	},
	20:{
		"is_taken":false,

		1:"Why are you here?",
		0:"To play"
	},
	21:{
		"is_taken":false,

		1:"Who won the elections?",
		0:"Joe biden"
	},
	22:{
		"is_taken":false,

		1:"2020 is _______",
		0:"Fun!!!"
	},
	23:{
		"is_taken":false,

		1:"What is the name of the hidden village of laughs",
		0:"Konohahhaha"
	},
	24:{
		"is_taken":false,

		1:"Cheems why stoopd?",
		0:"Bomkd"
	},
	25:{
		"is_taken":false,

		1:"Who said smart phones have brains?",
		0:"Zombie"
	},
	26:{
		"is_taken":false,

		1:"Do i write my name?",
		0:"Yes"
	},
	27:{
		"is_taken":false,

		1:"What type of envelope is heavy?",
		0:"Anvilope"
	},
}
