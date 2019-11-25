extends Control

var energy = 100
var total_energy = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var size = 0
	if (total_energy - energy) == 0:
		size = 0
	else:
		size = 255 * (total_energy - energy) / total_energy
	$ColorRect.rect_size.x = size
	$ColorRect.rect_position.x = 386 - size
