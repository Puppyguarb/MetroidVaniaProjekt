extends Node


var target:Player
var current_state :LimboState
var state_machine_owner

@onready var behavior_tree :BTPlayer = $BTPlayer

func _ready() -> void:
	behavior_tree.blackboard.set_var("is_agro",true)
	#_init_state_machine()

func set_agro(value :bool):
	pass

func get_distance_from_target():
	if not target: return
	var distance = state_machine_owner.global_position.distance_to(target.global_position)
	behavior_tree.blackboard.set_var("distance_from_target",distance)

func move():
	#updates the enemies move protocol to true
	pass

func attack():
	#changes state to attacking state.
	print("Attacking")

func _physics_process(delta):
	get_distance_from_target()

#func _init_state_machine() -> void:
	#hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	#hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	#hsm.initialize(self)
	#hsm.set_active(true)
