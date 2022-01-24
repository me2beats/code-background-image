tool
extends Button


func _pressed():
	var api = load("res://addons/code-bg-image/api.tres")
	api.plugin.remove_control_from_bottom_panel(owner)
