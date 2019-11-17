extends Control

var distance = 0
var target_distance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$map_point.rotation_degrees = distance / target_distance * 360
