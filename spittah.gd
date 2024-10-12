@tool
extends MeshInstance3D
const BULLET = preload("res://spittah_bullet.tscn")
const BlUE_MAT = preload("res://Materials/Blue.tres")
const RED_MAT = preload("res://Materials/Red.tres")
const PURPLE_MAT = preload("res://Materials/Purple.tres")
@onready var direction = %Direction
@export_range(1,3) var spit_tier : int : set = set_spit_tier
#@onready var fire_timer = %Timer
@export var auto_fire = true : set = set_auto_fire

func set_auto_fire(value):
	if auto_fire != value:
		%Timer.autostart = value
		auto_fire = value

func fire():
	var dir = direction.global_position - global_position
	dir = dir.normalized()
	
	var bullet = BULLET.instantiate()
	bullet.origin = self
	bullet.set_tier(spit_tier)
	Singleton.player.get_parent().add_child(bullet)
	bullet.global_position = self.global_position 
	bullet.apply_central_force(Vector3(dir*360))

func _on_timer_timeout() -> void: #this function spawns bullets
	fire()

func _on_area_3d_body_entered(body: Node3D) -> void: #this detects and deletes parried bullets
	if body is not Bullet:
		return
	if not body:
		return
	if body.is_tracking and not body.is_queued_for_deletion():
		body.queue_free()
	#Singleton.player.scale =Vector3(0.1,0.1,0.1)

func set_spit_tier(new_tier):
	if new_tier == spit_tier:
		return
	spit_tier = new_tier
	match new_tier:
		1:
			material_override = BlUE_MAT
		2:
			material_override = PURPLE_MAT
		3:
			material_override = RED_MAT
