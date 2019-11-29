extends Node2D

var velocity = 0
var side_velocity = 1
var drag_velocity = 0
var side_time = 0
var x = 0
var y = 0
var kv = 300
var width = 126
var height = 128

func _ready():
	width = width * scale.x
	height = height * scale.y
	position.x = x
	position.y = y

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
		if front.get("collider").name == 'road':
			x += side_velocity
		else:
			start = Vector2(front.position.x, front.position.y)
			end = Vector2(front.position.x - width, front.get("collider").get_node('../').position.y)
			var exception = [front.get("collider")]
			var left = space_state.intersect_ray(start, end, exception)
			start = Vector2(front.position.x, front.position.y)
			end = Vector2(front.position.x + width, front.position.y)
			var right = space_state.intersect_ray(start, end, exception)
			var left_or_right = false
			if left and right:
				left_or_right = randi() % 1
			if left:
				left_or_right = true
			if left_or_right:
				x -= side_velocity
			else:
				x += side_velocity
		if front.get("collider").get_node('../').get("velocity"):
			drag_velocity = abs(front.get("collider").get_node('../').velocity - velocity)
		else:
			drag_velocity = velocity - 0.1
	else:
		drag_velocity = 0
		
func get_front(space_state, delta_y):
	for dx in range(x - width / 2, x + width / 2):
		var start = Vector2(dx, y - height / 2)
		var end = Vector2(dx, y - delta_y * 10 - height / 2 - 10)
		var front = space_state.intersect_ray(start, end, [$ExRigidBody2D])
		if front:
			return front
	return {}