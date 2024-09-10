class_name Player

extends CharacterBody3D

const SPEED_NORMAL = 5.0
const SPEED_PARRY = 2.5

var is_parrying = false
var speed = SPEED_NORMAL
const JUMP_VELOCITY = 4.5
@onready var parry_window = %ParryWindowTimer
@onready var parry_cd = %ParryCdTimer
var is_immune = false #what is this for???
var immune_time = 0.0 #this too
var dodge_cooldown = 0.0
var default_dodge_cooldown = 0.4
var dodging = false
var dodge_speed = 1
var mirror_shards_current = 1
var mirror_shards_max = 1
signal mirror_shard_change
signal health_change
var look_dir = Vector3.ZERO
var current_hp = 2
var max_hp = 2
var dead = 0
var current_level = "res://Mane.tscn"
var is_perfect = false
var invulnerable = 0
var bullet_array = []

@onready var camera = %Camera3D

var input_dir := Vector2.ZERO

func _ready() -> void:
	Singleton.player = self

func dodge():
	if dodge_cooldown > 0:
		return
	dodge_cooldown = default_dodge_cooldown
	dodge_speed = 3.5
	dodging = true
	invuln(0.3)
	await get_tree().create_timer(0.3).timeout
	dodge_speed = 1
	dodging = false
	if is_parrying == true and dodging == false:
		speed = SPEED_NORMAL * 0.5

func invuln(time):
	invulnerable = 1
	set_collision_layer_value(1,false)
	%Area3D.set_collision_mask_value(2,false)
	await get_tree().create_timer(time).timeout
	set_collision_layer_value(1,true)
	%Area3D.set_collision_mask_value(2,true)
	invulnerable = 0

func _process(_delta):
	$DebugBox.global_position = calculate_target_pos(global_position.y - 1)
	look_dir = get_look_dir()
	if not dodging:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#mirror shards stuff
	if mirror_shards_current > mirror_shards_max:
		mirror_shards_current = mirror_shards_max
		mirror_shard_change.emit()
	if mirror_shards_current < mirror_shards_max and $MShartRegenTimer.is_stopped():
		$MShartRegenTimer.start()
	if mirror_shards_current > 0 and !($MShartRegenTimer.is_stopped()):
		$MShartRegenTimer.stop()
	evaluate_parry()

func get_look_dir():
	return ($DebugBox.global_position - global_position).normalized()

func evaluate_parry():
	if not is_parrying:
		return
	#Iterate backwards over the bullet array so we can safely delete entries.
	var array = range(bullet_array.size()-1,-1,-1)
	
	for i in array:
		var bullet = bullet_array[i]
		if is_perfect:
			bullet.activate_tracking()
			bullet.is_perfect = true
			change_mirror_shard(1)
			bullet_array.erase(bullet)
			continue # Like return, this just makes us move to the next entry in the array.
		
		match bullet.tier:
			1:
				bullet.activate_tracking()
				bullet_array.erase(bullet)
			2:
				bullet.deflect(get_look_dir())
				bullet_array.erase(bullet)
			3:
				pass # We do nothing for tier 3 bullets, they just pass through the shield.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if dead == 0:
		%PlayerMesh.rotation.y = atan2(look_dir.x,look_dir.z) + PI
	if not is_parrying:
		%ParryBox.rotation.y = atan2(look_dir.x,look_dir.z) + PI
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed * dodge_speed
		velocity.z = direction.z * speed * dodge_speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	dodge_cooldown -= delta
	if dead == 0:
		move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void: #handles hit/parry detection
	if body is not Bullet:
		return
	if dodging:
		change_mirror_shard(1)
	if not dodging and not is_parrying and invulnerable == 0:
		take_damage(1)
	await get_tree().create_timer(0.2).timeout
	if not body:
		return
	if not body.is_queued_for_deletion() and not is_parrying:
		body.queue_free()

func _input(event: InputEvent) -> void: #detects parry input
	if event.is_action_pressed("Parry") and parry_cd.is_stopped() and parry_window.is_stopped() and mirror_shards_current > 0 and dead == 0:
		parry()

	if Input.is_action_pressed("Dodge") and !is_parrying and not input_dir == Vector2.ZERO: #detects dodge input
		dodge()

func parry():
	is_parrying = true
	perfect_parry()
	change_mirror_shard(-1)
	change_parry_state(true)
	parry_window.start()

func perfect_parry():
	is_perfect = true
	await get_tree().create_timer(0.1).timeout
	is_perfect = false


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
		speed = SPEED_NORMAL*0.5
	elif value == false:
		speed = SPEED_NORMAL

func _on_parry_cd_timer_timeout() -> void: #parry cooldown
	$ParryCoolDown.visible = false

func calculate_target_pos(pos_y): #idk i didnt write this
	var mouse_2d_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.project_position(mouse_2d_pos,1) #project_ray_origin
	var dir = (mouse_world_pos - camera.global_position).normalized()
	var target_y = pos_y - camera.global_position.y
	return camera.global_position+dir*(target_y/dir.y)

func increase_mirror_shard_max(increaseamount):
	mirror_shards_max = mirror_shards_max + increaseamount
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

func take_damage(change):
	if dead == 1:
		pass
	invuln(0.5)
	change = change*-1
	if current_hp + change <= 0:
		die()
	else:
		if not current_hp + change > max_hp:
			current_hp = current_hp + change
		else:
			current_hp = max_hp
		health_change.emit()

func _on_parry_box_body_entered(body: Node3D) -> void: #handles bullet parrying
	
	if body is not Bullet:
		return
	if not body:
		return
	if body.is_queued_for_deletion():
		return
	
	bullet_array.append(body)

func _on_parry_box_body_exited(body: Node3D) -> void:
	if body is not Bullet:
		return
	bullet_array.erase(body)

func die():
	current_hp = 0
	dead = 1
	health_change.emit()
	if dead == 1:
		%"You Died".visible = true
		await get_tree().create_timer(3).timeout
		print("youre dead")
		get_tree().change_scene_to_file(current_level)
