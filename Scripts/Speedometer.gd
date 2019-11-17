extends Control

var velocity = 0
var max_velocity = 2.5
var velocity_unit


func _ready():
	$cursor.rotation = - 2.4
	velocity_unit = 4.8 / max_velocity 

func _process(delta):
	$cursor.rotation = velocity_unit * velocity - 2.4
