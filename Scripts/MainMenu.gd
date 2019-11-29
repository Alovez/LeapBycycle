extends Control

var settings
var settings_file
var level


# Called when the node enters the scene tree for the first time.
func _ready():
	settings_file = File.new()
	settings_file.open("user://settings.ini", File.READ)
	settings = parse_json(settings_file.get_line())
	settings_file.close()
	if not settings:
		settings = {}
	$SettingsLabel/SkipTutorial.pressed = settings.get("bypass_tutorial", false)
	need_continue()
	

func need_continue():
	var level_info_file = File.new()
	level_info_file.open("user://level_info.save", File.READ)
	var level_info = parse_json(level_info_file.get_line())
	if level_info:
		level = level_info.get("level", 0)
		$StartButton/Continue.visible = true
		$StartButton/Levels.visible = true
	else:
		$StartButton/Continue.visible = false
		$StartButton/Levels.visible = false
	level_info_file.close()



func _on_StartButton_button_up():
	get_tree().change_scene("res://Scene/Levels/StartStory.tscn")


func _on_ResetGame_pressed():
	$PopupPanel/ResetWarining.rect_position = Vector2(20, 10)
	$PopupPanel/ResetWarining.rect_size = Vector2(280, 100)
	$PopupPanel/ConfirmReset.rect_position = Vector2(120, 100)
	$PopupPanel/ConfirmReset.rect_size = Vector2(100, 40)
	$PopupPanel.popup()


func _on_ConfirmReset_button_up():
	var high_score_file = File.new()
	high_score_file.open("user://high_score.save", File.WRITE)
	high_score_file.store_line('')
	high_score_file.close()
	var level_info = File.new()
	level_info.open("user://level_info.save", File.WRITE)
	level_info.store_line('')
	level_info.close()
	$PopupPanel.hide()
	


func _on_Back_button_up():
	need_continue()
	$StartButton/MainPlayer.play_backwards("MainMenuOut")
	$SettingsLabel/SettingsPlayer.play_backwards("SettingsIn")


func _on_Settings_button_up():
	$StartButton/MainPlayer.play("MainMenuOut")
	$SettingsLabel/SettingsPlayer.play("SettingsIn")


func _on_SkipTutorial_toggled(button_pressed):
	settings["bypass_tutorial"] = button_pressed
	settings_file.open("user://settings.ini", File.WRITE)
	settings_file.store_line(to_json(settings))
	settings_file.close()


func _on_Continue_button_up():
	if level != null:
		get_tree().change_scene("res://Scene/Levels/Level%s.tscn" % str(level))


func _on_Levels_button_up():
	get_tree().change_scene("res://Scene/Menu/LevelChoose.tscn")
