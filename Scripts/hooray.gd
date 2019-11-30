extends ColorRect

var total_score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Z/AnimationPlayer.play("press_z")
	$Particles2D/AnimationPlayer.play("hooray")
	$Particles2D2/AnimationPlayer2.play("hooray")
	load_all_scores()
	$FinalVelocity.text = "Congratulations!!\nYour Finnal Total Velocity is\n%s\nThanks for your playing!"%str(total_score)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("boost"):
		$Z.visible = false
		$AnimationPlayer.play("Credits")

func load_all_scores():
	var score_file = File.new()
	score_file.open("user://high_score.save", File.READ)
	var scores = parse_json(score_file.get_line())
	total_score = 0
	for k in scores:
		total_score += scores[k]