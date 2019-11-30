extends Sprite

var velocity = 0
var acc_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	acc_time += delta
	if acc_time > 10:
		acc_time = 0
		$TrafficBody.position.x = abs($TrafficBody.position.x - 500)
		$GreenLight.enabled = not $GreenLight.enabled
		$RedLight.enabled = not $RedLight.enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
