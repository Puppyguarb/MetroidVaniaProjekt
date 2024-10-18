class_name DialogueUI extends MarginContainer



const CHAR_SHOW_RATE = 10

@onready var cam = %Camera3D
@onready var speech_label = %SpeechLabel
@onready var name_label = %NameLabel
@onready var anim = %AnimationPlayer

var current_shown_characters = 0.0
var current_dialogue = []
var dialogue_index = 0
var cam_node = null
var in_dialogue = false
var dialogue_setup_complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("start_dialogue",start_dialogue)
	
	#visible = false
	#await get_tree().process_frame
	#start_new_dialogue(load("res://UI/Dialogue/TestDialogueChain.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not in_dialogue:
		return
	
	handle_camera()
	
	if not dialogue_setup_complete:
		return
	
	if Input.is_action_just_pressed("Interact"):
		
		if is_showing_characters():
			current_shown_characters = -1
			speech_label.visible_characters = -1
		else:
			next_line()
	
	if is_showing_characters():
		current_shown_characters += delta * CHAR_SHOW_RATE
		speech_label.visible_characters = floori(current_shown_characters)

func handle_camera():
	if not cam_node:
		return
	
	cam.global_position = cam_node.global_position
	cam.global_rotation = cam_node.global_rotation

func is_showing_characters():
	return current_shown_characters < speech_label.text.length() and not current_shown_characters == -1



func next_line():
	if dialogue_index != current_dialogue.size():
		start_new_line(current_dialogue[dialogue_index])
		dialogue_index += 1
	else:
		end_dialogue()

func start_new_line(dialogue_segment : DialogueSegment):
	cam_node = get_tree().current_scene.find_child(dialogue_segment.node_name)
	if cam_node == null:
		printerr("Ya dingbat you typed the name wrong!!!")
	
	handle_camera()
	
	current_shown_characters = 0.0
	name_label.text = dialogue_segment.name
	speech_label.visible_characters = 0
	speech_label.text = dialogue_segment.speech

func start_dialogue(dialogue_chain : DialogueChain):
	if in_dialogue:
		printerr("Cannot start new dialogue when already in dialogue!")
		return
	
	if dialogue_setup_complete:
		print("Wait for dialogue animations to finish before starting a new dialogue.")
		return
	
	in_dialogue = true
	
	current_dialogue = dialogue_chain.chain
	dialogue_index = 0
	next_line()
	
	EventBus.emit_signal("dialogue_started")
	
	# Wait to allow showing characters until the animation finishes.
	anim.play("Appear")
	await anim.animation_finished
	dialogue_setup_complete = true

func end_dialogue():
	in_dialogue = false
	
	
	EventBus.emit_signal("dialogue_finished_before_setup")
	
	# Set setup to false only after the animation finishes.
	anim.play("Disappear")
	await anim.animation_finished
	dialogue_setup_complete = false
	
	EventBus.emit_signal("dialogue_finished_after_setup")
