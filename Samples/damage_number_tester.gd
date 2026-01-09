extends Node2D

@export var damage_number: PackedScene

var _instance: DamageNumber
var _test_value: int = 100


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if not _instance:
			_instance = damage_number.instantiate() as DamageNumber
			add_child(_instance)
			_instance.owner = self
			Debug.logm("Instantiated " + str(_instance))
		_test_value += 1
		_instance.play(str(_test_value), event.position)
