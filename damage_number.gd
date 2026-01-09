@icon("uid://bo7uc4yxwy1t4")
class_name DamageNumber
extends Node2D

signal finished

@export var label: Label
@export var subviewport: SubViewport
@export var particles: CPUParticles2D
@export var prefix: String = ""
@export var suffix: String = ""

var is_playing: bool

static var first_instances: Dictionary[PackedScene, DamageNumber] = {}


func _ready () -> void:
	is_playing = false
	particles.texture = subviewport.get_texture()
	particles.finished.connect(_handle_particles_finished)


func play (value: String, position: Vector2, color: Color = Color.WHITE) -> void:
	Debug.logm("Playing damage number: %s at %s" % [value, position])
	if is_playing:
		var other = Pooler.get_new(self) as DamageNumber
		var my_parent = get_parent()
		if other.get_parent() != my_parent:
			my_parent.add_child(other)
			other.owner = my_parent
		other.play(value, position, color)
		Debug.logm("Spawned pooled damage number instance")
		return
	Debug.logm("Using existing damage number instance")
	visible = true
	is_playing = true
	label.text = prefix + value + suffix
	global_position = position
	modulate = color
	particles.restart()


func _handle_particles_finished ():
	particles.emitting = false
	is_playing = false
	finished.emit()
	visible = false


static func play_static (prefab: PackedScene, value: String, position: Vector2, color: Color = Color.WHITE, parent: Node = null) -> void:
	if first_instances.has(prefab):
		first_instances[prefab].play(value, position, color)
		Debug.logm("Reusing existing damage number instance")
		return
	var instance = prefab.instantiate() as DamageNumber
	if parent:
		parent.add_child(instance)
		instance.owner = parent
	else:
		Global.get_tree().get_root().add_child(instance)
		instance.owner = Global.get_tree().get_root()
	Debug.logm("Creating first damage number instance")
	first_instances[prefab] = instance
	instance.play(value, position, color)


static func play_static_parent (prefab: PackedScene, value: String, position: Vector2, parent: Node = null) -> void:
	play_static(prefab, value, position, Color.WHITE, parent)


static func play_static_3d (prefab: PackedScene, value: String, position: Vector3, color: Color = Color.WHITE, parent: Node = null) -> void:
	var pos2d = Global.get_viewport().get_camera_3d().unproject_position(position)
	play_static(prefab, value, pos2d, color, parent)


static func play_static_3d_parent (prefab: PackedScene, value: String, position: Vector3, parent: Node = null) -> void:
	play_static_3d(prefab, value, position, Color.WHITE, parent)
