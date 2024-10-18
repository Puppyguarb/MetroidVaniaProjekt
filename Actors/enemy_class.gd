#Created by Seth on 10/18/24 
#Main preset for handling enemy archetecture 

class_name Enemy extends CharacterBody3D

@export var state_machine :PackedScene = preload("res://Actors/EnemyStateMachines/npc_state_machine.tscn")

@export var speed :float = 5.0
@export var brake_acceleration :float = 4.0
@export var acceleration :float = 1.0
@export var spin_rate :float = 2.0
@export var health_max :int = 5

var health_current :int
var ranged_attacks :Array[Resource]
var melee_attacks :Array[Resource]
var target_move_position :Vector3
var target_character :CharacterBody3D
var can_move :bool = true

func initialize_state_machine():
	state_machine.state_machine_owner = self
	state_machine.target = VariableManager.player


#Gets pathfinding information and applys movement 
func update_movement():
	#note pathfinder is its own custom module, to allow variety in enemy pathfinding.
	pass

func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, 2 * PI) - PI

func face_target(delta):
	if target_character == null: return
	var dir = target_character.global_position - global_position
	var target_angle = atan2(dir.x, dir.z)
	var current_angle = self.global_rotation.y
	var raw_angle_diff = target_angle - current_angle
	var angle_diff = wrap_angle(raw_angle_diff)
	if angle_diff < -PI:
		angle_diff += TAU

#MOVEMENT FUNCTIONS
func move_toward_direction(_delta):
	if target_move_position == null:
		return
	var dir :Vector3 = (self.global_position - target_move_position).normalized()
	dir = Vector3(dir.y,0,dir.x)
	velocity.x = move_toward(velocity.x,dir.x * speed,acceleration)
	velocity.z = move_toward(velocity.z,dir.z * speed,acceleration)

func brake():
	velocity.x = move_toward(velocity.x, 0, brake_acceleration)
	velocity.z = move_toward(velocity.z, 0, brake())

# Called when the node enters the scene tree for the first time.
func _ready():
	health_current = health_max
	initialize_state_machine()
	pass # Replace with function body.

func _physics_process(delta):
	if can_move:
		pass
		move_and_slide()
	pass
