extends Area3D

@export var dialogue_chain : DialogueChain

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("dialogue_started",_on_dialogue_started)
	EventBus.connect("dialogue_finished_after_setup",_on_dialogue_ended)


func _on_dialogue_started():
	if not player_in_area:
		return
	
	EventBus.emit_signal("toggle_speech_hint",false)

func _on_dialogue_ended():
	if not player_in_area:
		return
	
	EventBus.emit_signal("toggle_speech_hint",true)

func _input(event):
	if not player_in_area:
		return
	
	if event.is_action_pressed("Interact"):
		trigger()
		get_viewport().set_input_as_handled()

func trigger():
	if VariableManager.dialogue_ui.in_dialogue:
		return
	
	EventBus.emit_signal("start_dialogue",dialogue_chain)


func _on_body_entered(_body):
	player_in_area = true
	EventBus.emit_signal("toggle_speech_hint",true)


func _on_body_exited(_body):
	player_in_area = false
	EventBus.emit_signal("toggle_speech_hint",false)
