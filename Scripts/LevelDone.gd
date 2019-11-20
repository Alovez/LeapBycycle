extends Control

var level_info

# Called when the node enters the scene tree for the first time.
func _ready():
	level_info = load_level()
	$Velocity.text = str(level_info.final_velocity)

func load_level():
	var level_file = File.new()
	level_file.open("user://level_info.save",  File.READ)
	var level_info = parse_json(level_file.get_line())
	level_file.close()
	return level_info



func _on_NextLevel_button_up():
	var next_level = level_info.get('level', 0) + 1
	var next_scene 
	if next_level < 2:
		next_scene = "res://Scene/Levels/Level%s.tscn" % next_level
	else:
		next_scene = "res://Scene/Levels/StartStory.tscn"
	get_tree().change_scene(next_scene)


func _on_Retry_button_up():
	get_tree().change_scene("res://Scene/Levels/Level%s.tscn" % level_info.get('level', 0))
