tool
extends OptionButton



func _on_item_selected(mode:int):
	var Settings = preload("settings_singleton.tres")
	Settings.set_setting("stretch_mode", mode)
	preload("api.tres").set_stretch_mode(mode)
