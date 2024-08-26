extends MeshInstance3D
const BULLET = preload("res://spittah_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var bullet = BULLET.instantiate()
	bullet.origin = self
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position
	bullet.apply_central_force(Vector3(0,0,420))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Bullet:
		return
	if not body:
		return
	if body.is_tracking and not body.is_queued_for_deletion():
		body.queue_free()
		print("youdad")
