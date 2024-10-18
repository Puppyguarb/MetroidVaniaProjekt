extends CharacterBody3D


const SPEED = 5.0
const BRAKE_ACCELERATION = 4.0
const ACCELERATION = 2.5
const SPIN_RATE = 2.0


@onready var spitter = %Spitter
@onready var state_machine = $BasicScrapper


func _ready():
	initialize_state_machine()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Safe to remove
	face_player(delta)
	
	#if state_machine.current_state == state_machine.Walk:
		#move_toward_direction(delta)
	#else:
		#brake()
	#
	#move_and_slide()

func initialize_state_machine():
	state_machine.state_machine_owner = self
	state_machine.target = Singleton.player

func face_player(delta):
	var dir = Singleton.player.global_position - global_position
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

# Needs to be in a physics loop!
func move_toward_direction(delta):
	var dir = Vector2.from_angle(global_rotation.y)#Singleton.player.global_position - global_position
	dir = dir.normalized()
	dir = Vector3(dir.y,0,dir.x)
	velocity.x = move_toward(velocity.x,dir.x * SPEED,ACCELERATION)
	velocity.z = move_toward(velocity.z,dir.z * SPEED,ACCELERATION)

func brake():
	velocity.x = move_toward(velocity.x, 0, BRAKE_ACCELERATION)
	velocity.z = move_toward(velocity.z, 0, BRAKE_ACCELERATION)

func fire():
	spitter.fire()
