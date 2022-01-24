tool
extends TextureRect



enum TextureStretchModes {
	KEEP_ASPECT_BL,
	KEEP_ASPECT_BR,
	KEEP_ASPECT_UL,
	KEEP_ASPECT_UR,
	KEEP_ASPECT_CENTER,
	KEEP_ASPECT_COVER,
	KEEP_CENTER,
	KEEP_BL,
	KEEP_BR,
	KEEP_UL,
	KEEP_UR,
	TILE,
	SCALE,
	SCALE_ON_EXPAND,
}

# use it instead of Texture.stretch_mode
export(TextureStretchModes) var texture_stretch_mode setget setter_texture_stretch_mode

# use it instead of Texture.scale; should be positive
export var texture_scale: = Vector2.ONE setget setter_texture_scale

# fit again in the next fit
# it seems this needed for ScriptEditor TextEdit
export var extra_fit = false

# poop
func setter_texture_stretch_mode(val):
	texture_stretch_mode = val

	var scale = texture_scale.abs()
	rect_scale = scale
	flip_h = false
	flip_v = false

	match val:
		TextureStretchModes.KEEP_ASPECT_BL:
			rect_scale = scale*Vector2(1,-1)
			flip_v = true
			stretch_mode = STRETCH_KEEP_ASPECT

		TextureStretchModes.KEEP_ASPECT_BR:
			rect_scale = scale*Vector2(-1,-1)
			flip_h = true
			flip_v = true
			stretch_mode = STRETCH_KEEP_ASPECT

		TextureStretchModes.KEEP_ASPECT_UR:
			flip_h = true
			rect_scale = scale*Vector2(-1,1)
			stretch_mode = STRETCH_KEEP_ASPECT

		TextureStretchModes.KEEP_ASPECT_UL:
			stretch_mode = STRETCH_KEEP_ASPECT


		TextureStretchModes.KEEP_BL:
			rect_scale = scale*Vector2(1,-1)
			flip_v = true
			stretch_mode = STRETCH_KEEP

		TextureStretchModes.KEEP_BR:
			rect_scale = scale*Vector2(-1,-1)
			flip_h = true
			flip_v = true
			stretch_mode = STRETCH_KEEP

		TextureStretchModes.KEEP_UR:
			flip_h = true
			rect_scale = scale*Vector2(-1,1)
			stretch_mode = STRETCH_KEEP


		TextureStretchModes.KEEP_UL:
			stretch_mode = STRETCH_KEEP

		TextureStretchModes.KEEP_ASPECT_CENTER:
			stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
		TextureStretchModes.KEEP_ASPECT_COVER:
			stretch_mode = STRETCH_KEEP_ASPECT_COVERED
		TextureStretchModes.KEEP_CENTER:
			stretch_mode = STRETCH_KEEP_CENTERED
		TextureStretchModes.SCALE:
			stretch_mode = STRETCH_SCALE
		TextureStretchModes.SCALE_ON_EXPAND:
			stretch_mode = STRETCH_SCALE_ON_EXPAND
		TextureStretchModes.TILE:
			stretch_mode = STRETCH_TILE

	_on_resized()


func setter_texture_scale(new_scale):
	texture_scale = new_scale
	setter_texture_stretch_mode(texture_stretch_mode)
	_on_resized()
#	rect_scale = new_scale
	


func _on_resized():
	if ! is_inside_tree(): return
#	set_anchors_preset(Control.PRESET_WIDE)

	fit()



func fit():
	match texture_stretch_mode:
		TextureStretchModes.KEEP_ASPECT_BR, TextureStretchModes.KEEP_BR:
			rect_position.x =rect_size.x
			rect_position.y =rect_size.y
		TextureStretchModes.KEEP_ASPECT_BL, TextureStretchModes.KEEP_BL:
			rect_position.x = 0
			rect_position.y =rect_size.y
		TextureStretchModes.KEEP_ASPECT_UR, TextureStretchModes.KEEP_UR:
			rect_position.x = rect_size.x
			rect_position.y =0
		_:
			rect_position.x = 0
			rect_position.y =0

