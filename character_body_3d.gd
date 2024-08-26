extends CharacterBody3D

var is_immune = false
var immune_time = 0.0
var dodge_cooldown = 0.0
var default_dodge_cooldown = 2.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var dodge_speed = 1


@onready var camera = $Node3D/Camera3D

func dodge():
	if dodge_cooldown > 0: 
		return
	dodge_cooldown = default_dodge_cooldown
	dodge_speed = 3
	await get_tree().create_timer(0.5).timeout
	dodge_speed = 1
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Dodge"):
		dodge()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * dodge_speed
		velocity.z = direction.z * SPEED * dodge_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	dodge_cooldown -= delta
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Bullet:
		return
	await get_tree().create_timer(1).timeout
	if not body:
		return
	if not body.is_queued_for_deletion():
		body.queue_free()
