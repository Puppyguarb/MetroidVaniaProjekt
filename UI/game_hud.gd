class_name GameHud
extends CanvasLayer

@onready var mirror_shard_label = %MirrorShardLabel
@onready 
var health_label = %HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.game_hud = self
	await get_tree().process_frame # < Wait 1 process frame
	Singleton.player.connect("mirror_shard_change",_on_mirror_shard_change)
	Singleton.player.connect("health_change",_on_health_change)


func _on_mirror_shard_change():
	mirror_shard_label._on_character_body_3d_mirror_shard_change()

func _on_health_change():
	health_label._on_character_body_3d_health_change()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
