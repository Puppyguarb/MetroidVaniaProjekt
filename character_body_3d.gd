class_name Player

extends CharacterBody3D

var is_parrying = false
const DEFAULT_SPEED = 5.0
var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var parry_window = %ParryWindowTimer
@onready var parry_cd = %ParryCdTimer
var is_immune = false
var immune_time = 0.0
var dodge_cooldown = 0.0
var default_dodge_cooldown = 0.8
var dodging = false
var dodge_speed = 1
var mirror_shards_current = 1
var mirror_shards_max = 1
signal mirror_shard_change
var look_dir = Vector3.ZERO

@onready var camera = %Camera3D

func _ready() -> void:
	Singleton.player = self

func dodge():
	if dodge_cooldown > 0:
		return
	dodge_cooldown = default_dodge_cooldown
	dodge_speed = 3
	dodging = true
	await get_tree().create_timer(0.5).timeout
	dodge_speed = 1
	dodging = false
	if is_parrying == true and dodging == false:
		SPEED = DEFAULT_SPEED * 0.5

func _process(_delta):
	$DebugBox.global_position = calculate_target_pos(global_position.y - 1)
	look_dir = ($DebugBox.global_position - global_position).normalized()
	
	
	#mirror shards stuff
	if mirror_shards_current > mirror_shards_max:
		mirror_shards_current = mirror_shards_max
		mirror_shard_change.emit()
	if mirror_shards_current < mirror_shards_max and $MShartRegenTimer.is_stopped():
		$MShartRegenTimer.start()
	if mirror_shards_current > 0 and !($MShartRegenTimer.is_stopped()):
		$MShartRegenTimer.stop()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	%PlayerMesh.rotation.y = atan2(look_dir.x,look_dir.z) + PI
	if not is_parrying:
		%ParryBox.rotation.y = atan2(look_dir.x,look_dir.z) + PI
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
	if not body.is_queued_for_deletion() and not is_parrying:
		body.queue_free()
		if dodging:
			change_mirror_shard(1)
		if not dodging and not is_parrying:
			pass #damage code woo
# and !dodging
func _input(event: InputEvent) -> void: #detects parry input
	if event.is_action_pressed("Parry") and parry_cd.is_stopped() and parry_window.is_stopped() and mirror_shards_current > 0:
		is_parrying = true
		change_mirror_shard(-1)
		change_parry_state(true)
		parry_window.start()

	if Input.is_action_pressed("Dodge") and !is_parrying: #detects dodge input
		dodge()

func _on_parry_window_timer_timeout() -> void: #triggers when parry window closes, starts cooldown
	is_parrying = false
	change_parry_state(false)
	$ParryCoolDown.visible = true
	parry_cd.start()

func change_parry_state(value):
	$ParryWindow.visible = value
	%CrappyShield.visible = value
	%ShieldCollision.disabled = not value
	if not dodging and value == true:
		SPEED = DEFAULT_SPEED*0.5
	elif value == false:
		SPEED = DEFAULT_SPEED

func _on_parry_cd_timer_timeout() -> void: #parry cooldown
	$ParryCoolDown.visible = false

func calculate_target_pos(pos_y): #idk i didnt write this
	var mouse_2d_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.project_position(mouse_2d_pos,1) #project_ray_origin

	var dir = (mouse_world_pos - camera.global_position).normalized()

	var target_y = pos_y - camera.global_position.y

	return camera.global_position+dir*(target_y/dir.y)

func increase_mirror_shard_max():
	mirror_shards_max = mirror_shards_max + 1
	mirror_shards_current = mirror_shards_max
	mirror_shard_change.emit()

func _on_m_shart_regen_timer_timeout() -> void:
	change_mirror_shard(1)

func change_mirror_shard(change):
	if not mirror_shards_current + change > mirror_shards_max:
		mirror_shards_current = mirror_shards_current + change
	else:
		mirror_shards_current = mirror_shards_max
	mirror_shard_change.emit()


func _on_parry_box_body_entered(body: Node3D) -> void:
	if body is not Bullet:
		return
	if not body:
		return
	if not body.is_queued_for_deletion():
		if is_parrying:
			body.activate_tracking()
