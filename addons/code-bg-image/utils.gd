

static func find_node_by_class_path(node:Node, class_path:Array)->Node:
	var res:Node

	var stack = []
	var depths = []

	var first = class_path[0]
	for c in node.get_children():
		if c.get_class() == first:
			stack.push_back(c)
			depths.push_back(0)

	if not stack: return res
	
	var max_ = class_path.size()-1

	while stack:
		var d = depths.pop_back()
		var n = stack.pop_back()

		if d>max_:
			continue
		if n.get_class() == class_path[d]:
			if d == max_:
				res = n
				return res

			for c in n.get_children():
				stack.push_back(c)
				depths.push_back(d+1)

	return res




static func find_child_by_class(node:Node, cls:String):
	for child in node.get_children():
		if child.get_class() == cls:
			return child




static func get_script_tab_container(scr_ed:ScriptEditor)->TabContainer:
	return find_node_by_class_path(scr_ed, ['VBoxContainer', 'HSplitContainer', 'TabContainer']) as TabContainer



static func get_script_text_editor(scr_ed:ScriptEditor, idx:int)->Container:
	var tab_cont = get_script_tab_container(scr_ed)
	return tab_cont.get_child(idx)


static func get_current_script_idx(scr_ed:ScriptEditor)->int:
	var current = scr_ed.get_current_script()
	var opened = scr_ed.get_open_scripts()
	
	return opened.find(current)



static func get_code_editor(scr_ed:ScriptEditor, idx:int)->Container:
	var empty:Container
	var scr_text_ed = get_script_text_editor(scr_ed, idx)
	if not scr_text_ed: return empty
	return find_node_by_class_path(scr_text_ed, ['VSplitContainer', 'CodeTextEditor']) as Container



static func get_text_edit(scr_ed:ScriptEditor, idx:int)->TextEdit:
	var empty:TextEdit
	var code_ed = get_code_editor(scr_ed, idx)
	if not code_ed: return empty
	return find_node_by_class_path(code_ed, ['TextEdit']) as TextEdit

static func get_current_text_ed(scr_ed:ScriptEditor)->TextEdit:
	var empty:TextEdit
	if not scr_ed.get_current_script(): return empty
	var idx = get_current_script_idx(scr_ed)
	return get_text_edit(scr_ed, idx)



# buffer



#	var parent = Utils.find_node_by_class_path(
#		base, [
#			'VBoxContainer', 
#			'HSplitContainer',
#			'HSplitContainer',
#			'HSplitContainer',
#			'VBoxContainer',
#			'VSplitContainer',
#			'PanelContainer',
#			'VBoxContainer'
#		]
#	)
