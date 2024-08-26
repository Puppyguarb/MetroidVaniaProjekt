class_name Bullet
extends RigidBody3D
var origin = null
var is_tracking = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_tracking():
	is_tracking = true
	print("yourmom")

func _physics_process(delta: float) -> void:
	if !is_tracking:
		return
	var dir:Vector3 = origin.global_position-global_position
	dir=dir.normalized()
	set_linear_velocity(dir*10)
