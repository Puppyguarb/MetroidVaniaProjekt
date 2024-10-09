extends MarginContainer

const CHAR_SHOW_RATE = 10

@onready var cam = %Camera3D
@onready var speech_label = %SpeechLabel
@onready var name_label = %NameLabel

var current_shown_characters = 0.0
var current_dialogue = []
var dialogue_index = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	await get_tree().process_frame
	#start_new_dialogue(load("res://UI/Dialogue/TestDialogueChain.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		
		if is_showing_characters():
			current_shown_characters = -1
			speech_label.visible_characters = -1
		else:
			next_line()
	
	
	if is_showing_characters():
		current_shown_characters += delta * CHAR_SHOW_RATE
		speech_label.visible_characters = floori(current_shown_characters)


func is_showing_characters():
	return current_shown_characters < speech_label.text.length() and not current_shown_characters == -1

func start_new_dialogue(dialogue_chain : DialogueChain):
	current_dialogue = dialogue_chain.chain
	dialogue_index = 0
	next_line()

func next_line():
	if dialogue_index != current_dialogue.size():
		start_new_line(current_dialogue[dialogue_index])
		dialogue_index += 1
	else:
		end_dialogue()
	

func start_new_line(dialogue_segment : DialogueSegment):
	visible = true
	var cam_node = get_tree().current_scene.find_child(dialogue_segment.node_name)
	
	current_shown_characters = 0.0
	name_label.text = dialogue_segment.name
	speech_label.visible_characters = 0
	speech_label.text = dialogue_segment.speech
	if cam_node != null:
		cam.global_position = cam_node.global_position
		cam.global_rotation = cam_node.global_rotation
	else:
		printerr("Ya dingbat you typed the name wrong!!!")

func end_dialogue():
	visible = false
