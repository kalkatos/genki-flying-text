@icon("uid://bo7uc4yxwy1t4")
@tool
class_name DamageNumber
## Component specialized in displaying animated floating numbers (e.g., damage, healing) in 2D or 3D space.
extends Node2D

signal finished

@export var label: Label
@export var subviewport: SubViewport
@export var particles: CPUParticles2D
@export var prefix: String = ""
@export var suffix: String = ""

@export_tool_button("Test Play")
var b1:
	get: return func(): particles.restart() if particles else null

var is_playing: bool

static var first_instances: Dictionary[PackedScene, DamageNumber] = {}


## Initializes the damage number, connecting particle signals and setting up the visual components.
func _ready () -> void:
	if Engine.is_editor_hint():
		return
	is_playing = false
	# Link subviewport texture to particles for label rendering
	particles.texture = subviewport.get_texture()
	particles.finished.connect(_handle_particles_finished)


func play_as_is () -> void:
	# Plays the animation using the current label text, position, and color without modifying them.
	play(label.text, global_position, modulate)


func play_at_position (value: String = "") -> void:
	play(value, global_position, modulate)


## Plays the damage number animation with the given string value and position.
## [param value]: The text to display (e.g., "15").
## [param position]: World-space 2D position to start the animation.
## [param color]: Optional color for the text and particles.
func play (value: String, position: Vector2, color: Color = Color.WHITE) -> void:
	# Handle pooling: spawn a duplicate if already playing
	if is_playing:
		var other = Pooler.get_new(self) as DamageNumber
		var my_parent = get_parent()
		if other.get_parent() != my_parent:
			my_parent.add_child(other)
			other.owner = my_parent
		other.play(value, position, color)
		return
	visible = true
	is_playing = true
	label.text = prefix + value + suffix
	global_position = position
	modulate = color
	particles.restart()


## Internal handler callback triggered when particle animation completes.
func _handle_particles_finished ():
	particles.emitting = false
	is_playing = false
	finished.emit()
	visible = false


## Static helper to play a damage number from a prefab, managing persistence and initialization.
static func play_static (prefab: PackedScene, value: String, position: Vector2, color: Color = Color.WHITE, parent: Node = null) -> void:
	# Reuse base instance if it already exists
	if first_instances.has(prefab) and is_instance_valid(first_instances[prefab]):
		first_instances[prefab].play(value, position, color)
		return
	# Instantiate first occurrence or if the previous instance was freed
	var instance = prefab.instantiate() as DamageNumber
	if parent:
		parent.add_child(instance)
		instance.owner = parent
	else:
		Global.get_tree().get_root().add_child(instance)
		instance.owner = Global.get_tree().get_root()
	first_instances[prefab] = instance
	instance.play(value, position, color)


## Static helper to play a damage number with a default white color and specific parent.
static func play_static_parent (prefab: PackedScene, value: String, position: Vector2, parent: Node = null) -> void:
	play_static(prefab, value, position, Color.WHITE, parent)


## Static helper to play a 2D damage number at a projected 3D world position.
static func play_static_3d (prefab: PackedScene, value: String, position: Vector3, color: Color = Color.WHITE, parent: Node = null) -> void:
	# Unproject 3D position to screen space
	var pos2d = Global.get_viewport().get_camera_3d().unproject_position(position)
	play_static(prefab, value, pos2d, color, parent)


## Static helper to play a 2D damage number at a 3D position with specific parent and default color.
static func play_static_3d_parent (prefab: PackedScene, value: String, position: Vector3, parent: Node = null) -> void:
	play_static_3d(prefab, value, position, Color.WHITE, parent)
