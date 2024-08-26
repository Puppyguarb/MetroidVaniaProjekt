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
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position
	bullet.apply_central_force(Vector3(0,0,420))
