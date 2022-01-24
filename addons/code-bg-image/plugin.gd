tool
extends EditorPlugin



const Utils = preload("utils.gd")

var api


const tool_item: = "Code Background Image Settings"
const bottom_panel_tab_name: = "Code Background Image"


var scr_ed:ScriptEditor

var editor_settings:EditorSettings



func _enter_tree():

	api = preload("api.tres")
	api.init(self)

	scr_ed = get_editor_interface().get_script_editor()
	scr_ed.connect("editor_script_changed", self, "on_script_changed")

	on_script_changed(null)

	# restore textedit color when hiding EditorSettings dialog
	var base = get_editor_interface().get_base_control()
	var ed_settings:AcceptDialog = Utils.find_child_by_class(base, 'EditorSettingsDialog')
	ed_settings.connect("hide", self, 'on_ed_settings_hide')

	add_tool_menu_item(tool_item, self, "on_settings_pressed")


func enable_plugin():
	yield(get_tree(), "idle_frame")
	
	add_control_to_bottom_panel(api.settings_control, bottom_panel_tab_name)
	make_bottom_panel_item_visible(api.settings_control)
	
	get_editor_interface().set_main_screen_editor("Script")



func on_ed_settings_hide():
	api.recent_textedit.set("custom_colors/background_color", Color(0,0,0,0))
	yield(get_tree(), "idle_frame")
	api.recent_textedit.set("custom_colors/background_color", Color(0,0,0,0))

	api.update_from_settings()
	api.settings_control.update_from_settings()

func on_script_changed(_script:Script):
	var text_ed:TextEdit = Utils.get_current_text_ed(scr_ed)
	if not text_ed:return
	api.recent_textedit = text_ed


	api.refresh()


func _exit_tree():

	remove_control_from_bottom_panel(api.settings_control)
	remove_tool_menu_item(tool_item)

	api.remove_texture()


	api.control.free()
	api.plugin = null
	api.recent_textedit = null

	if api.settings_control:
		api.settings_control.free()

	api.settings_control = null

	api.control = null
	api.base = null



func on_settings_pressed(_what):
	var settings_control = api.settings_control

	if !settings_control.is_inside_tree():
		add_control_to_bottom_panel(settings_control, bottom_panel_tab_name)

	make_bottom_panel_item_visible(settings_control)

	get_editor_interface().set_main_screen_editor("Script")






















