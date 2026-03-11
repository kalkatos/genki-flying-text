@tool
## Editor plugin script for registering the DamageNumber custom type in the Godot editor.
extends EditorPlugin

const CUSTOM_TYPE_NAME := "DamageNumber"


## Called when the plugin is enabled; registers the DamageNumber custom type.
func _enter_tree () -> void:
	add_custom_type(CUSTOM_TYPE_NAME, "Control", preload("damage_number.gd"), preload("uid://bo7uc4yxwy1t4"))


## Called when the plugin is disabled; removes the DamageNumber custom type.
func _exit_tree () -> void:
	remove_custom_type(CUSTOM_TYPE_NAME)
