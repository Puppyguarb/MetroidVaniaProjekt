class_name Bullet
extends RigidBody3D
var origin = null
var is_tracking = false
const BlUE_MAT = preload("res://Materials/Blue.tres")
const GREEN_MAT = preload("res://Materials/Green.tres")
@onready var boolhit = $MeshInstance3D

func activate_tracking():
	is_tracking = true
	boolhit.material_override = GREEN_MAT
	print("your parry hit")

func _physics_process(delta: float) -> void:
	if !is_tracking:
		return
	var dir:Vector3 = origin.global_position-global_position
	dir=dir.normalized()
	set_linear_velocity(dir*10)


func _on_bullet_delete_timer_timeout() -> void:
	if not self.is_queued_for_deletion():
		self.queue_free()
