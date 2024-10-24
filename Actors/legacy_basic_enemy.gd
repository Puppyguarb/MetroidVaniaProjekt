extends RigidBody3D

@onready var intended_dir = Vector3.ZERO
@onready var spinamount = deg_to_rad(150)
var intended_angle = 0

func _process(delta):
	var current_angle = self.global_rotation.y
	var angle_difference = wrap_angle(intended_angle - current_angle)
	
	if angle_difference != 0:
		global_rotation.y = move_toward(current_angle, current_angle + angle_difference, spinamount * delta)

func _on_rotation_timer_timeout() -> void:
	intended_dir = VariableManager.player.global_position - global_position
	intended_angle = atan2(intended_dir.x, intended_dir.z)

# Function to wrap angles between -π and π
func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, 2 * PI) - PI

func _on_movement_timer_timeout() -> void:
	#var dir:Vector3 = origin.global_position-global_position
	var dir = Vector2.from_angle(global_rotation.y)
	dir=dir.normalized()
	#apply_impulse(Vector3(dir.x,0,dir.y)*100)
	#set_linear_velocity(Vector3(dir.x,0,dir.y)*100)
	printerr("Dingerooni")
	#print(linear_velocity)

func _physics_process(delta):
	var dir = Vector2.from_angle(global_rotation.y)
	#apply_central_force(Vector3(dir.x,0,dir.y)*10*delta)
	set_linear_velocity(Vector3(dir.x,0,dir.y)*1)
	printerr(linear_velocity)
