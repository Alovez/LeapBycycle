extends Node2D


#40 ~ 167
var velocity = 1
var side_velocity = 1
var drag_velocity = 0
var side_time = 0
var x = 184
var y = 432
var kv = 300
var left_body = false
var right_body = false
var width = 64
var height = 128

# Called when the node enters the scene tree for the first time.
func _ready():
	width = width * scale.x
	height = height * scale.y
	position.x = x
	position.y = y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var delta_y = (velocity - drag_velocity) * delta * kv
	avoid_obstacles(delta_y)
	delta_y = (velocity - drag_velocity) * delta * kv
	y -= delta_y
	position.y = y
	position.x = x

func avoid_obstacles(delta_y):
	var space_state = get_world_2d().direct_space_state
	var start = Vector2(x, position.y)
	var end = Vector2(x, position.y - (delta_y * 10))
	var front = get_front(space_state, delta_y)
	if front:
		if front.get("collider").name == 'TrafficBody':
			drag_velocity = velocity
		else:
			if front.get("collider").name == 'road':
				x += side_velocity
			else:
				start = Vector2(front.position.x, front.position.y)
				end = Vector2(front.position.x - width, front.get("collider").get_node('../').position.y)
				var left = space_state.intersect_ray(start, end, [front.get("collider")])
				start = Vector2(front.position.x, front.position.y)
				end = Vector2(front.position.x + width, front.position.y)
				var right = space_state.intersect_ray(start, end, [front.get("collider")])
				var left_or_right = false
				if left and right:
					left_or_right = randi() % 1
				if left:
					left_or_right = true
				if left_or_right and x > 40:
					x -= side_velocity
				elif not left_or_right and x < 267:
					x += side_velocity
			var target = front.get("collider").get_node('../')
			if target.get("velocity") and target.get("drag_velocity"):
				var target_v = target.velocity - target.drag_velocity
				drag_velocity = abs(target_v - velocity)
			else:
				drag_velocity = 0
	else:
		drag_velocity = 0
		
func get_front(space_state, delta_y):
	for dx in range(x - width / 2, x + width / 2):
		var start = Vector2(dx, y - height / 2)
		var end = Vector2(dx, y - delta_y * 10 - height / 2 - 10)
		var front = space_state.intersect_ray(start, end, [$RigidBody2D])
		if front:
			return front
	return {}

#func _on_TurnSensor_body_entered(body):
#	var body_node = body.get_node('../')
#
#	drag_velocity = abs(body_node.velocity - velocity) - 0.1
#	if left_body or x - 20 < 35:
#		side_velocity = velocity
#		side_time = abs(body_node.position.x - x) / abs(side_velocity)
#	elif right_body or x + 20 > 250:
#		side_velocity = - velocity
#		side_time = abs(body_node.position.x - x) / abs(side_velocity)
#	else:
#		side_velocity = 0
#		drag_velocity = abs(body_node.velocity - velocity) + 0.1
#
#
#
#func _on_leftSensor_body_entered(body):
#	left_body = true
#
#func _on_leftSensor_body_exited(body):
#	left_body = false
#
#func _on_RightSensor_body_entered(body):
#	right_body = true
#
#
#func _on_RightSensor_body_exited(body):
#	right_body = false
#
#
#func _on_TurnSensor_body_exited(body):
#	drag_velocity = 0
