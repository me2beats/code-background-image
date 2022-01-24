tool
extends Resource

var plugin:EditorPlugin
var recent_textedit:TextEdit

var Settings

var settings_control:Control

var control:Control

var default_settings:Dictionary

var default_normal:StyleBox
var default_focus:StyleBox

var new_normal:StyleBox
var new_focus:StyleBox

const color_transparent: = Color(0,0,0,0)

const default_bg_settings_path = "text_editor/highlighting/background_color"
var editor_settings:EditorSettings



const tool_item: = "Code Background Image Settings"
const bottom_panel_tab_name: = "Code Background Image"


var base:Control



func init(plugin:EditorPlugin):
	
	
	self.plugin = plugin
	var ed_interface:EditorInterface = plugin.get_editor_interface()
	
	control = preload("bg.tscn").instance()

	default_settings = {
	"image_path" : ["res://icon.png", TYPE_STRING],
	"stretch_mode" : [1, TYPE_INT],
	"modulate" : [control.get_node("Texture").modulate, TYPE_COLOR],
	"scale" : [Vector2.ONE, TYPE_VECTOR2],
	
	}
	
	
	editor_settings =  ed_interface.get_editor_settings()
	base = ed_interface.get_base_control()

	Settings = preload("settings_singleton.tres")
	Settings.init(plugin, default_settings, "code_bg_image")


	settings_control = load("res://addons/code-bg-image/Settings.tscn").instance()
	settings_control.init(self)
	
	update_from_settings()




	init_styles()


func update_from_settings():
	var image:Texture = load(Settings.get_setting("image_path"))
	if image:
		set_texture(image, false)
	var stretch_mode = Settings.get_setting("stretch_mode")
	set_stretch_mode(stretch_mode, false)
	var modulate = Settings.get_setting("modulate")
	set_modulate(modulate, false)
	var scale = Settings.get_setting("scale")
	set_scale(scale, false)

	restore_bg()


func set_transparent_bg():
	if recent_textedit:
		recent_textedit.set("custom_colors/background_color", Color(0,0,0,0))


# ugly!!
func restore_bg():
	if !is_instance_valid(base): return
	yield(base.get_tree().create_timer(1.5), "timeout")
	set_transparent_bg()
	if !is_instance_valid(base): return
	yield(base.get_tree(),"idle_frame")
	set_transparent_bg()
	if !is_instance_valid(base): return
	yield(base.get_tree().create_timer(0.5), "timeout")
	set_transparent_bg()

func set_texture(texture:Texture, restore_bg: = true):
	var texture_rect:TextureRect= control.get_node("Texture")
	texture_rect.texture = texture
	if restore_bg:	restore_bg()


func set_stretch_mode(mode:int, restore_bg:= true):
	control.get_node("Texture").texture_stretch_mode = mode
	if restore_bg:	restore_bg()


func set_modulate(modulate:Color, restore_bg:= true):
	control.get_node("Texture").modulate = modulate
	if restore_bg:	restore_bg()


func set_scale(scale:Vector2, restore_bg:= true):
	control.get_node("Texture").texture_scale = scale
	if restore_bg:	restore_bg()

func refresh():

	remove_texture()
	add_texture(recent_textedit)



func add_texture(text_ed:TextEdit, restore_styles: = true):
#	var control = control

	var default_bg:Color = editor_settings.get_setting(default_bg_settings_path)
	control.get_node("ColorRect").color = default_bg

	control.get_node("Texture").texture = load(Settings.get_setting("image_path"))

	text_ed.add_child(control)

	if restore_styles:
		text_ed.set("custom_styles/normal", new_normal)
		text_ed.set("custom_styles/focus", new_focus)

		if ! text_ed.get("custom_colors/background_color").is_equal_approx(color_transparent):
			text_ed.set("custom_colors/background_color", color_transparent)


#only removes from parent
func remove_texture(restore_styles: = true):

	if not is_instance_valid(control) or not control.get_parent(): return
	var text_ed = control.get_parent()

	if not text_ed is TextEdit: return
	text_ed.remove_child(control)

	text_ed.set("custom_styles/normal", default_normal)
	text_ed.set("custom_styles/focus", default_focus)
	var default_bg:Color = editor_settings.get_setting(default_bg_settings_path)
	text_ed.set("custom_colors/background_color", default_bg)



func init_styles():
	var theme = plugin.get_editor_interface().get_base_control().theme

	default_normal = theme.get_stylebox("normal", 'TextEdit')
	default_focus = theme.get_stylebox("focus", 'TextEdit')

	new_normal = default_normal.duplicate()
	new_focus = default_focus.duplicate()

	new_normal.set("bg_color", color_transparent)
	new_focus.set("bg_color", color_transparent)

