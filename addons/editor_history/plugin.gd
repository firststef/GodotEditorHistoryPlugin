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
	ea.add_on_action_executing("SceneTreeEditor/nothing_selected", Callable(self, "on_start_selected_changed"))
	ea.add_on_action_executed("SceneTreeEditor/nothing_selected", Callable(self, "on_end_selected_changed"))

func _exit_tree():
	print("Exiting EditorHistory plugin ", dock)
	remove_control_from_docks(dock)
	dock.queue_free()
	ea.clear_execute_cb()

func on_start_selected_changed():
	pass

func on_end_selected_changed():
	var item = item_scene.instance()
	item.get_node("HBoxContainer/Label").text = "nothing_selected"
	item.full_action_name = "SceneTreeEditor/nothing_selected"
	item.connect("re_action", Callable(self, "_re_action"))
	dock.get_node("ScrollContainer/VBoxContainer").add_child(item)

func _re_action(action_name: String):
	ea.execute_action(action_name, Array())
