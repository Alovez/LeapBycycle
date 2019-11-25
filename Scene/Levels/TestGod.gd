extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		var v = state.linear_velocity.y
		var drag = v * v * 0.5
		var force = Vector2(0, -1)
		add_central_force(force)
	print(state.total_linear_damp)
	print(state.linear_velocity)