extends MeshInstance3D
const BULLET = preload("res://spittah_bullet.tscn")
@onready var dir = $"Direction Facing".global_position - global_position

func _on_timer_timeout() -> void: #this function spawns bullets
	var bullet = BULLET.instantiate()
	bullet.origin = self
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position #lines 9 and 10 decide the direction and force of the bullet
	bullet.apply_central_force(Vector3(dir*360))

func _on_area_3d_body_entered(body: Node3D) -> void: #this detects and deletes parried bullets
	if body is not Bullet:
		return
	if not body:
		return
	if body.is_tracking and not body.is_queued_for_deletion():
		body.queue_free()
	#Singleton.player.scale =Vector3(0.1,0.1,0.1)
