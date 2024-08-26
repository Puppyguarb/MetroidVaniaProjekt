extends CharacterBody3D

var is_parrying = false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var parry_window = %ParryWindowTimer
@onready var parry_cd = %ParryCdTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Bullet:
		return
	await get_tree().create_timer(0.2).timeout
	if not body:
		return
	if not body.is_queued_for_deletion():
		if is_parrying:
			body.activate_tracking()
		else:
			body.queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Parry") and parry_cd.is_stopped() and parry_window.is_stopped():
		is_parrying = true
		$ParryWindow.visible = true
		print("yoursister")
		parry_window.start()

func _on_parry_window_timer_timeout() -> void:
	is_parrying = false
	$ParryWindow.visible = false
	$ParryCoolDown.visible = true
	parry_cd.start()

func _on_parry_cd_timer_timeout() -> void:
	$ParryCoolDown.visible = false
