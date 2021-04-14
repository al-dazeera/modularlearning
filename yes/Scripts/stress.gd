extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can=true

func start():
	$Tween.interpolate_property(self,"rect_position",rect_position,Vector2(rect_position.x,200),2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.start()
	data.stressed=true


func _on_Button_pressed():
	data.reset()
	data.resetted=true
	data.stress=0
	get_parent().can_wobble=false
	$Tween.interpolate_property(self,"rect_position",rect_position,Vector2(rect_position.x,-300),2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Tween.start()
	data.unblur(get_parent().get_node("CanvasLayer/ColorRect"))
	for num in range(len(data.text_array)):
		data.text_array[num]["is_taken"]=false
	get_parent().module()
	data.stressed=false
