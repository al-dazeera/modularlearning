extends Node2D
var priority=0
var amplitude=0
var target="Camera2D"
export (String) var property="offset"
onready var node=get_parent()
func start(duration=0.8,frequency=15,amplitude=16,priority=0):

	if priority>=self.priority:
		self.priority=priority
		self.amplitude=amplitude
		$duration.wait_time=duration
		$frequency.wait_time=1/float(frequency)
		$duration.start()
		$frequency.start()
		new_shake()
func new_shake():
	var rand
	if node is TextureProgress:
		rand=rand_range(-amplitude,amplitude)
	else:
		rand=Vector2()
		rand.x=rand_range(-amplitude,amplitude)
		rand.y=rand_range(-amplitude,amplitude)
	
	$Tween.interpolate_property(node,property,node.get(property),rand,$frequency.wait_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.start()

func reset():
	var zero
	if node is TextureProgress:
		zero=0
	else:
		zero=Vector2()
	priority=0
	$Tween.interpolate_property(node,property,node.get(property),zero,$frequency.wait_time,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.start()
func _on_frequency_timeout():
	new_shake()


func _on_duration_timeout():
	reset()
	$frequency.stop()
