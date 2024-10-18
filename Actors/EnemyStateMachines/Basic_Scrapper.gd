extends Node


var target:Player
var current_state 
var state_machine_owner
var states = [
	"walk",
	"attack",
	"idle",
	]

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
	set_state(1)

func idle():
	set_state(3)

func attack():
	set_state(2)
	state_machine_owner.fire()

func _physics_process(delta):
	get_distance_from_target()

func set_state(state):
	current_state = states[state-1]

#func _init_state_machine() -> void:
	#hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	#hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	#hsm.initialize(self)
	#hsm.set_active(true)
