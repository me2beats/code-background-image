tool
extends HBoxContainer

var Settings = preload("settings_singleton.tres")

var api:Resource
var plugin:EditorPlugin
var fs_dock:FileSystemDock

func update_from_settings():
	$VBoxContainer/HBoxContainer/HBoxContainer/LineEdit.text = Settings.get_setting("image_path")
	$VBoxContainer/HBoxContainer2/OptionButton.selected = Settings.get_setting("stretch_mode")
	$VBoxContainer/HBoxContainer5/HBoxContainer/HBoxContainer/x.text = str(Settings.get_setting("scale").x)
	$VBoxContainer/HBoxContainer5/HBoxContainer/HBoxContainer2/y.text = str(Settings.get_setting("scale").y)
	$VBoxContainer/HBoxContainer3/Modulate.color = Settings.get_setting("modulate")


func init(api:Resource):
	self.api = api
	plugin = api.plugin
	fs_dock = plugin.get_editor_interface().get_file_system_dock()
	
	if !Engine.editor_hint: return
	var theme: = plugin.get_editor_interface().get_base_control().theme
	$VBoxContainer/HBoxContainer/HBoxContainer/LoadImage.icon = theme.get_icon("Folder", "EditorIcons")

	var option_button: = $VBoxContainer/HBoxContainer2/OptionButton

	for key in preload("texture_rect.gd").TextureStretchModes.keys():
		option_button.add_item(key)


	var image_path = Settings.get_setting("image_path")
	$"VBoxContainer/HBoxContainer/HBoxContainer/LineEdit".text = image_path


	update_from_settings()



var dragged_path:String


func _notification(what):
	match what:
		NOTIFICATION_DRAG_BEGIN:
			if not api: return
			if fs_dock.get_global_rect().has_point(fs_dock.get_global_mouse_position()):
				dragged_path =  plugin.get_editor_interface().get_current_path()
		NOTIFICATION_DRAG_END:
			if not api: return
			if !dragged_path: return
			var settings_control:Control = api.settings_control
			if not settings_control or not settings_control.is_inside_tree() or not settings_control.visible: return
			if not settings_control.get_global_rect().has_point(get_global_mouse_position()): return
			var texture:Texture = load(dragged_path)
			if not texture: return

			Settings.set_setting('image_path', dragged_path)
			api.set_texture(texture)
			update_from_settings()
			dragged_path = ""


func _input(event):
	if !(event is InputEventMouseMotion and dragged_path): return
	var settings_control:Control = api.settings_control
	if not settings_control.get_global_rect().has_point(get_global_mouse_position()): return
	yield(get_tree(),"idle_frame")

	if Input.get_current_cursor_shape() ==CURSOR_FORBIDDEN:
		Input.set_default_cursor_shape(CURSOR_CAN_DROP)
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		
		
