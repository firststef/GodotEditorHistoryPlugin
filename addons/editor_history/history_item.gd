@tool
extends Panel

# @export var params: Array
@export var full_action_name: String

signal re_action

func _enter_tree():
	pass

func _ready():
	pass

func _on_Button_pressed():
	emit_signal("re_action", full_action_name)
