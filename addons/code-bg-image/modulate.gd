tool
extends ColorPickerButton



func _on_popup_closed():
	var Settings = preload("settings_singleton.tres")
	Settings.set_setting("modulate", color)
	preload("api.tres").set_modulate(color)
