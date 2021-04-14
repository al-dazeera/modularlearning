extends Node


func op(list,mode):
	#modes: 0-add,1-mult,2-div
	var res=0
	if mode<2:
		for num in range(len(list)):
			match mode:
				0:
					res+=list[num]
				1:
					if num==0:
						res+=list[num]
					else:
						res*=list[num]
	else:
		res=list[0]/list[1]
	return res
	
