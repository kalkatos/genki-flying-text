@tool
extends EditorPlugin

const CUSTOM_TYPE_NAME := "DamageNumber"


func _enter_tree() -> void:
	add_custom_type(CUSTOM_TYPE_NAME, "Control", preload("damage_number.gd"), preload("uid://bo7uc4yxwy1t4"))


func _exit_tree() -> void:
	remove_custom_type(CUSTOM_TYPE_NAME)
