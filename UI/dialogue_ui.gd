extends MarginContainer

@onready var cam = %Camera3D
@onready var speech_label = %SpeechLabel
@onready var name_label = %NameLabel

var showing_characters = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	var dialogue_segment = load("res://UI/Dialogue/DialogueTest.tres")
	start_new_line(dialogue_segment)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_new_line(dialogue_segment : DialogueSegment):
	var cam_node = get_tree().current_scene.find_child(dialogue_segment.node_name)
	
	showing_characters = true
	name_label.text = dialogue_segment.name
	speech_label.visible_characters = 0
	speech_label.text = dialogue_segment.speech
	if cam_node != null:
		cam.global_position = cam_node.global_position
		cam.global_rotation = cam_node.global_rotation
	else:
		printerr("Ya dingbat you typed the name wrong!!!")
