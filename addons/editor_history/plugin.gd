@tool
extends EditorPlugin

var ea: EditorActions
var dock_scene = preload("res://addons/editor_history/history_dock.tscn")
var dock
var item_scene = preload("res://addons/editor_history/history_item.tscn")

func _enter_tree():
	dock = dock_scene.instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	ea = get_editor_interface().get_editor_actions()
	ea.add_on_action_executing("SceneTreeEditor/nothing_selected", Callable(self, "on_start_selected_changed"), ["SceneTreeEditor/nothing_selected"])
	ea.add_on_action_executed("SceneTreeEditor/nothing_selected", Callable(self, "on_end_selected_changed"), ["SceneTreeEditor/nothing_selected"])

func _exit_tree():
	remove_control_from_docks(dock)
	dock.queue_free()
	ea.clear_execute_cb()

func on_start_selected_changed(action_name: String):
	print("executing " + action_name)

func on_end_selected_changed(action_name: String):
	var item = item_scene.instance()
	var splits = action_name.split("/")
	var text_n = splits[1] if (splits.size() == 2) else action_name
	item.get_node("HBoxContainer/Label").text = text_n
	item.full_action_name = action_name
	item.connect("re_action", Callable(self, "_re_action"))
	dock.get_node("ScrollContainer/VBoxContainer").add_child(item)

func _re_action(action_name: String):
	ea.execute_action(action_name, Array())
