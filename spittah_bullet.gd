class_name Bullet
extends RigidBody3D
var origin = null
var is_tracking = false
var is_perfect = false
var is_deflected = false
const BlUE_MAT = preload("res://Materials/Blue.tres")
const RED_MAT = preload("res://Materials/Red.tres")
const PURPLE_MAT = preload("res://Materials/Purple.tres")
const GREEN_MAT = preload("res://Materials/Green.tres")
const DEFLECT_DEVIATION = 10
const DEFLECT_MIN_DEVIATION = 15
const PARRY_MULT = 10

@onready var mesh = %MeshInstance3D
var tier = 1
# Deflected bullets can be re-parried, but not until a half second later.
func deflect(away_dir):
	if is_deflected:
		return
	
	set_collision_layer_value(2,false)
	is_deflected = true
	#var away_dir = global_position - Singleton.player.global_position
	# Add a random amount of deviation. To do this, we should convert the direction to an angle, and then back.
	var additional_deviation = randi_range(-DEFLECT_DEVIATION,DEFLECT_DEVIATION)
	var angle = atan2(away_dir.z,away_dir.x) + deg_to_rad(DEFLECT_MIN_DEVIATION*sign(additional_deviation)) + deg_to_rad(additional_deviation)
	var dir_2d = Vector2.from_angle(angle)
	var dir_3d = Vector3(dir_2d.x,randf_range(0.05,0.1),dir_2d.y).normalized()
	set_linear_velocity(dir_3d*PARRY_MULT*2)
	
	await get_tree().create_timer(.5).timeout
	is_deflected = false
	set_collision_layer_value(2,true)

func activate_tracking(): #this makes it green when parried
	if origin == null:
		return
	is_tracking = true
	mesh.material_override = GREEN_MAT

func _physics_process(_delta:float) -> void: #this tracks the bullet back to its creator
	if !is_tracking or origin == null:
		return
	if is_perfect:
		var dir:Vector3 = origin.global_position-global_position
		dir=dir.normalized()
		set_linear_velocity(dir*PARRY_MULT*2.5)
	else:
		var dir:Vector3 = origin.global_position-global_position
		dir=dir.normalized()
		set_linear_velocity(dir*PARRY_MULT)

func set_tier(new_tier):
	if not is_node_ready():
		await self.ready
	tier = new_tier
	match new_tier:
		1:
			mesh.material_override = BlUE_MAT
		2:
			mesh.material_override = PURPLE_MAT
		3:
			mesh.material_override = RED_MAT

func _on_bullet_delete_timer_timeout() -> void: #this deletes the bullet on a timer if its not parried
	if not self.is_queued_for_deletion() and !is_tracking:
		self.queue_free()
