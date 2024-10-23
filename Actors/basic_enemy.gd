extends CharacterBody3D


const SPEED = 5.0
const BRAKE_ACCELERATION = 4.0
const ACCELERATION = 2.5
const SPIN_RATE = 2.0

var is_agro :bool = true

@onready var spitter = %Spitter
@onready var state_machine = $BasicScrapper
@onready var nav_agent = $NavigationAgent3D


func _ready():
	initialize_state_machine()
	nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func initialize_state_machine():
	state_machine.state_machine_owner = self
	await get_tree().process_frame
	state_machine.target = VariableManager.player

func _physics_process(delta):
	# Add the gravity.
	if is_agro:
		set_movement_target(VariableManager.player.position)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Safe to remove
	face_player(delta)
	
	#Pathfinding
	if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		print("is empty")
		return
	if nav_agent.is_navigation_finished():
		print("no path")
		return
	apply_movement()

func apply_movement():
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * SPEED
	if not state_machine.current_state: return
	if state_machine.current_state == "walk":
		print("is walking")
		if nav_agent.avoidance_enabled:
			nav_agent.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
	else:
		brake()

func face_player(delta):
	var dir = VariableManager.player.global_position - global_position
	var target_angle = atan2(dir.x, dir.z)
	var current_angle = self.global_rotation.y
	var raw_angle_diff = target_angle - current_angle
	var angle_diff = wrap_angle(raw_angle_diff)
	if angle_diff < -PI:
		angle_diff += TAU
	
	if angle_diff != 0:
		global_rotation.y = move_toward(current_angle, current_angle + angle_diff, SPIN_RATE * delta)

# Function to wrap angles between -π and π
func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, 2 * PI) - PI

#Old movement method, using pathfinding now instead.
#func move_toward_direction(_delta):
	#var dir = Vector2.from_angle(global_rotation.y)#VariableManager.player.global_position - global_position
	#dir = dir.normalized()
	#dir = Vector3(dir.y,0,dir.x)
	#velocity.x = move_toward(velocity.x,dir.x * SPEED,ACCELERATION)
	#velocity.z = move_toward(velocity.z,dir.z * SPEED,ACCELERATION)


func set_movement_target(movement_target: Vector3):
	nav_agent.set_target_position(movement_target)


func brake():
	velocity.x = move_toward(velocity.x, 0, BRAKE_ACCELERATION)
	velocity.z = move_toward(velocity.z, 0, BRAKE_ACCELERATION)

func fire():
	spitter.fire()


func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
