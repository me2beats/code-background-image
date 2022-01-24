tool
extends HBoxContainer


func _ready():
	pass

var Settings = preload("settings_singleton.tres")


func _on_x_text_entered(new_text):
	_set_scale()
	

func _on_y_text_entered(new_text):
	_set_scale()

func _set_scale():
	var x = float($HBoxContainer/x.text)
	var y = float($HBoxContainer2/y.text)
	var new_scale = Vector2(x, y)
	Settings.set_setting("scale", new_scale)
	preload("api.tres").set_scale(new_scale)
