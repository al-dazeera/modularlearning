extends Node2D

var amp=40

var num_add
var w1_add
var w2_add

var num_mult
var w1_mult
var w2_mult

var num_3rd
var w1_3rd
var w2_3rd

var number
var num
var add_list : Array
var mult_list : Array
var list_3rd : Array

var list_w : Array

var mxn=Vector2()
var text=""
var modes=[0,1,2]
var m

func _1st_ans(m):
	randomize()

	mxn=Vector2(-amp,amp)
	match m:
		0:
			var _range=int(rand_range(2,6))
			for num in _range:
				randomize()
				number=round(rand_range(mxn.x,mxn.y))
				add_list.append(number)
				if num!=0:
					while number==0:
						randomize()
						number=round(rand_range(mxn.x,mxn.y))
					if number<0:
						text+="+("+String(number)+")"
					else:
						text+="+"+String(number)
				else:
					text+=String(number)
						
		1:
			var _range=int(rand_range(2,4))
			for num in _range:
				randomize()
				number=round(rand_range(mxn.x,mxn.y))
				while number==0:
					randomize()
					number=round(rand_range(mxn.x,mxn.y))
				mult_list.append(number)
				text+="("+String(number)+")"
		2:
			for i in range(2):
				randomize()
				number=round(rand_range(mxn.x,mxn.y))
				while number==0:
					randomize()
					number=round(rand_range(mxn.x,mxn.y))
				list_3rd.append(number)
				match i:
					0:
						text+="("+String(number)+")"
					1:
						text+="/("+String(number)+")"

func re_rand(_var,val):
	var new_val
	for i in range(30):
		if _var==val:
			new_val=rand_range((amp+i)-val,(amp+i)+val)
	_var=new_val

func find_diff(main_val,per):
	return main_val*per

func re_run(_m):
	match _m:
		0:
			re_rand(w1_add,num_add)
			re_rand(w2_add,num_add)
			re_rand(w1_add,w2_add)
			re_rand(w2_add,w1_add)
			list_w.append(w1_add)
			list_w.append(w2_add)
		1:
			re_rand(w1_mult,num_mult)
			re_rand(w2_mult,num_mult)
			re_rand(w1_mult,w2_mult)
			re_rand(w2_mult,w1_mult)
			list_w.append(w1_mult)
			list_w.append(w2_mult)
func init():
	var d=0.2
	var d_rand
	m=modes[round(rand_range(0,2))]
	_1st_ans(m)
	match m:
		0:
			num_add=math.op(add_list,m)
			num=num_add
			d_rand=find_diff(num_add,d)
			w1_add=round(rand_range(num_add-d_rand,d_rand+num_add))
			w2_add=round(rand_range(num_add-d_rand,d_rand+num_add))
			for i in range(5):
				re_run(m)
			#print("res: ",num_add," | w1: ",w1_add, " | w2: ",w2_add  )
		1:
			num_mult=math.op(mult_list,m)
			num=num_mult
			d_rand=find_diff(num_mult,d)
			w1_mult=round(rand_range(num_mult-d_rand,d_rand+num_mult))
			w2_mult=round(rand_range(num_mult-d_rand,d_rand+num_mult))
			for i in range(5):
				re_run(m)
			#print("res: ",num_mult," | w1: ",w1_mult, " | w2: ",w2_mult  )
		2:
			num_3rd=math.op(list_3rd,m)
			num=num_3rd
			d_rand=find_diff(num_3rd,d)
			w1_3rd=rand_range(num_3rd-d_rand,num_3rd+d_rand)
			w2_3rd=rand_range(num_3rd-d_rand,num_3rd+d_rand)
			num_3rd=stepify(num_3rd,0.001)
			w1_3rd=stepify(w1_3rd,0.001)
			w2_3rd=stepify(w2_3rd,0.001)
			re_rand(w1_3rd,num_3rd)
			re_rand(w2_3rd,num_3rd)
			if typeof(num_3rd)==TYPE_INT:
				round(w1_3rd)
				round(w2_3rd)
			list_w.append(w1_3rd)
			list_w.append(w2_3rd)
			#print("res: ",num_3rd," | w1: ",w1_3rd, " | w2: ",w2_3rd  )
#		text=""
#		add_list.clear()
#		mult_list.clear()
#		list_3rd.clear()
