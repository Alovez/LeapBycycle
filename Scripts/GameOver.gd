extends Control

var level_info

# Called when the node enters the scene tree for the first time.
func _ready():
	level_info = load_level()

func load_level():
	var level_file = File.new()
	level_file.open("user://level_info.save",  File.READ)
	var level_info = parse_json(level_file.get_line())
	level_file.close()
	return level_info


func _on_Button_button_up():
	get_tree().change_scene("res://Scene/Levels/Level%s.tscn" % str(level_info.get('level', 0)))
