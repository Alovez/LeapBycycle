extends Control

var level_info

# Called when the node enters the scene tree for the first time.
func _ready():
	level_info = load_level()
	record_high_score()
	$Velocity.text = str(level_info.final_velocity)

func load_level():
	var level_file = File.new()
	level_file.open("user://level_info.save",  File.READ)
	var level_info = parse_json(level_file.get_line())
	level_file.close()
	return level_info

func record_high_score():
	var level = level_info.get('level', 0)
	var score_file = File.new()
	score_file.open("user://high_score.save", File.READ)
	var scores = parse_json(score_file.get_line())
	score_file.close()
	if scores:
		if scores.get(str(level), 0) < level_info.final_velocity:
			scores[level] = level_info.final_velocity
			score_file.open("user://high_score.save", File.WRITE)
			score_file.store_line(to_json(scores))
	else:
		scores = {}
		scores[level] = level_info.final_velocity
		score_file.open("user://high_score.save", File.WRITE)
		score_file.store_line(to_json(scores))
	score_file.close()

func _on_NextLevel_button_up():
	var next_level = level_info.get('level', 0) + 1
	var next_scene 
	if next_level < 4:
		next_scene = "res://Scene/Levels/Level%s.tscn" % next_level
	else:
		next_scene = "res://Scene/Levels/StartStory.tscn"
	get_tree().change_scene(next_scene)


func _on_Retry_button_up():
	get_tree().change_scene("res://Scene/Levels/Level%s.tscn" % level_info.get('level', 0))


func _on_BackToLevel_button_up():
	get_tree().change_scene("res://Scene/Menu/LevelChoose.tscn")
