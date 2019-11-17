extends Node2D

var velocity = 0
var side_velocity = 1
var drag_velocity = 0
var side_time = 0
var x = 0
var y = 0
var kv = 400
var left_body = false
var right_body = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = x
	position.y = y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	y -= (velocity - drag_velocity) * delta * kv
	if side_time > 0:
		x += side_velocity
		side_time -= 1
	position.y = y
	position.x = x

func _on_TurnSensor_body_entered(body):
	var body_node = body.get_node('../')
	
	drag_velocity = abs(body_node.velocity - velocity) - 0.1
	if left_body or x - 20 < 35:
		side_velocity = velocity
		side_time = abs(body_node.position.x - x) / abs(side_velocity)
	elif right_body or x + 20 > 250:
		side_velocity = - velocity
		side_time = abs(body_node.position.x - x) / abs(side_velocity)
	else:
		side_velocity = 0
		drag_velocity = abs(body_node.velocity - velocity) + 0.1
	


func _on_leftSensor_body_entered(body):
	left_body = true

func _on_leftSensor_body_exited(body):
	left_body = false

func _on_RightSensor_body_entered(body):
	right_body = true


func _on_RightSensor_body_exited(body):
	right_body = false


func _on_TurnSensor_body_exited(body):
	drag_velocity = 0
