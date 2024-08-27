extends MeshInstance3D
const BULLET = preload("res://spittah_bullet.tscn")
@onready var dir = $"Direction Facing".global_position - global_position

func _on_timer_timeout() -> void:
	var bullet = BULLET.instantiate()
	bullet.origin = self
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position
	bullet.apply_central_force(Vector3(dir*360))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Bullet:
		return
	if not body:
		return
	if body.is_tracking and not body.is_queued_for_deletion():
		body.queue_free()
		print("your projectile hit")
