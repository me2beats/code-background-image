tool
extends ToolButton



func _pressed():
	$FileDialog.popup_centered()

func _on_FileDialog_file_selected(path):
	var texture = load(path)
	if !texture is Texture: return
	
	$"../LineEdit".text = path
	var Settings = preload("settings_singleton.tres")
	Settings.set_setting("image_path", path)

	var api = load("res://addons/code-bg-image/api.tres")

	api.set_texture(texture)




	
