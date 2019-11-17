extends Node2D


func _init():
	pass
	
func load_level():
	var level_file = File.new()
	level_file.open("user://level_info.save",  File.READ)
	var level_info = parse_json(level_file.get_line())
	level_file.close()
	return level_info