tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here
	# Add the new type with a name, a parent type, a script and an icon
	add_custom_type("Dialog", "Node", preload("dialog/dialog.gd"), preload("icon.png"))
	add_custom_type("DialogChoice", "Node", preload("dialog/choice.gd"), preload("icon.png"))
	add_custom_type("Condition", "Node", preload("condition/condition.gd"), preload("icon.png"))
	add_custom_type("ConditionItem", "Condition", load("condition/condition_item.gd"), preload("icon.png"))


func _exit_tree():
	# Clean-up of the plugin goes here
	# Always remember to remove it from the engine when deactivated
	remove_custom_type("Dialog")
	remove_custom_type("DialogChoice")