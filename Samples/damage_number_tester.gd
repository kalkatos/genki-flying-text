## Sample script for testing DamageNumber instantiation and display via click events.
extends Node2D

@export var damage_number: PackedScene

var _instance: DamageNumber
var _test_value: int = 100


## Handles input events to spawn or update damage numbers on click.
func _input (event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		# Instantiate damage number if it doesn't exist
		if not _instance:
			_instance = damage_number.instantiate() as DamageNumber
			add_child(_instance)
			_instance.owner = self
			print("Instantiated " + str(_instance))
		_test_value += 1
		# Play animation at click position
		_instance.play(str(_test_value), event.position)
