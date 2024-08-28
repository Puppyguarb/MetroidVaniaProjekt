extends CharacterBody3D

var is_parrying = false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var parry_window = %ParryWindowTimer
@onready var parry_cd = %ParryCdTimer
var is_immune = false
var immune_time = 0.0
var dodge_cooldown = 0.0
var default_dodge_cooldown = 2.0
var dodging = false
var dodge_speed = 1
var mirror_shards_current = 1
var mirror_shards_max = 1
signal mirror_shard_change

@onready var camera = %Camera3D

func dodge():
	if dodge_cooldown > 0:
		return
	dodge_cooldown = default_dodge_cooldown
	dodge_speed = 3
	dodging = true
	await get_tree().create_timer(0.5).timeout
	dodge_speed = 1
	dodging = false

func _process(delta):
	$DebugBox.global_position = calculate_target_pos(global_position.y - 1)
	var dir = ($DebugBox.global_position - global_position).normalized()
	$MeshInstance3D.rotation.y = atan2(dir.x,dir.z) + PI
	
	#mirror shards stuff
	if mirror_shards_current > mirror_shards_max:
		print("too many shards faggot")
		mirror_shards_current = mirror_shards_max
		mirror_shard_change.emit()
	#if mirror_shards_current == 0:
		#$MShartRegenTimer.start

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
		velocity.x = direction.x * SPEED * dodge_speed
		velocity.z = direction.z * SPEED * dodge_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	dodge_cooldown -= delta
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void: #handles hit/parry detection 
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
		if dodging:
			print("you dodged")
			mirror_shards_current = mirror_shards_current + 1
			mirror_shard_change.emit()
		if not dodging and not is_parrying:
			print("you took damage")

func _input(event: InputEvent) -> void: #detects parry input
	if event.is_action_pressed("Parry") and parry_cd.is_stopped() and parry_window.is_stopped() and !dodging and mirror_shards_current > 0:
		is_parrying = true
		mirror_shards_current = mirror_shards_current - 1
		mirror_shard_change.emit()
		print("ur shards are currently ",mirror_shards_current)
		$ParryWindow.visible = true
		print("you started parrying")
		parry_window.start()

	if Input.is_action_pressed("Dodge") and !is_parrying: #detects dodge input
		dodge()

func _on_parry_window_timer_timeout() -> void: #triggers when parry window closes, starts cooldown
	is_parrying = false
	$ParryWindow.visible = false
	$ParryCoolDown.visible = true
	parry_cd.start()

func _on_parry_cd_timer_timeout() -> void: #parry cooldown
	$ParryCoolDown.visible = false

func calculate_target_pos(pos_y): #idk i didnt write this
	var mouse_2d_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.project_position(mouse_2d_pos,1) #project_ray_origin

	var dir = (mouse_world_pos - camera.global_position).normalized()

	var target_y = pos_y - camera.global_position.y

	return camera.global_position+dir*(target_y/dir.y)

#func _on_m_shart_regen_timer_timeout() -> void:
	#print("gay")
	#mirror_shards_current = mirror_shards_current + 1
