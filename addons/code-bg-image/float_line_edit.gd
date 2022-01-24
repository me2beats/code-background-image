tool
extends LineEdit


var regex: = RegEx.new()
var oldtext: = ""

func _ready():
	regex.compile("^[0-9\\.]*$")
	connect("text_changed", self, "_on_LineEdit_text_changed")

func _on_LineEdit_text_changed(new_text:String):
	var old_cur_pos = caret_position
	if regex.search(new_text):
		text = new_text
		oldtext = text
		set_cursor_position(old_cur_pos)
	else:
		var caret_offset = new_text.length()-oldtext.length()
		text = oldtext
		set_cursor_position(old_cur_pos-caret_offset)

func get_value():
	return(int(text))
