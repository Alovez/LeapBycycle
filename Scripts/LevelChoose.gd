extends Control

var current_level = '0'
var scores = {}
var released_button = false

func _ready():
	$Z/Z_blink.play("z_blink")
	

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("RollLevels")
	
	if Input.is_action_pressed("ui_left"):
		$AnimationPlayer.play_backwards("RollLevels")
	
	if not Input.is_action_pressed("boost"):
		released_button = true
	
	if released_button and Input.is_action_pressed("boost"):
		if current_level == '0':
			get_tree().change_scene("res://Scene/Levels/Level0.tscn")
		elif current_level == '1':
			get_tree().change_scene("res://Scene/Levels/Level1.tscn")
		elif current_level == '2':
			get_tree().change_scene("res://Scene/Levels/Level2.tscn")

func waiting_input(level_num):
	$AnimationPlayer.stop(false)
	$Label.text = "Level " + str(level_num)
	$HighScore.text = "Final Velocity\n"+str(scores.get(level_num, 0.00))
	current_level = level_num
	
func get_high_score():
	var score_file = File.new()
	score_file.open("user://high_score.save", File.READ)
	scores = parse_json(score_file.get_line())