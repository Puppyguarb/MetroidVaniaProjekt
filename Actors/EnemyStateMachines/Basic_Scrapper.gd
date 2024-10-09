extends Node


@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState


func _ready() -> void:
	_init_state_machine()

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	hsm.initialize(self)
	hsm.set_active(true)
