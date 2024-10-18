class_name GameHud
extends CanvasLayer

@onready var mirror_shard_label = %MirrorShardLabel
@onready 
var health_label = %HealthLabel

@onready var fps_counter = %FPSCounter

@onready var speech_hint_anim = %SpeechAnim
@onready var speech_hint = %SpeechHint
@onready var dialogue_ui = %DialogueUI

# Called when the node enters the scene tree for the first time.
func _ready():
	VariableManager.game_hud = self
	VariableManager.dialogue_ui = dialogue_ui
	await get_tree().process_frame # < Wait 1 process frame
	VariableManager.player.connect("mirror_shard_change",_on_mirror_shard_change)
	VariableManager.player.connect("health_change",_on_health_change)
	EventBus.connect("toggle_speech_hint",toggle_speech_hint)


func _on_mirror_shard_change():
	mirror_shard_label._on_character_body_3d_mirror_shard_change()

func _on_health_change():
	health_label._on_character_body_3d_health_change()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fps_counter.set_text("FPS: %d" % [Engine.get_frames_per_second()])

func toggle_speech_hint(value):
	if dialogue_ui.in_dialogue and value:
		return
	
	if not speech_hint_anim.is_playing():
		if value:
			speech_hint_anim.speed_scale = 1.0
			speech_hint_anim.play("Toggle")
		else:
			speech_hint_anim.speed_scale = -1.0
			speech_hint_anim.play("Toggle",-1,1.0,true)
	else:
		speech_hint_anim.speed_scale *= -1.0
