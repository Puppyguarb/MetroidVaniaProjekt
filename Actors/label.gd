extends Label

@onready var boobsman = $"../../../.."

@onready var yaytext = boobsman.mirror_shards_current

func _on_character_body_3d_mirror_shard_change() -> void:
	yaytext = boobsman.mirror_shards_current
	self.text = "shards: " + str(yaytext)
	print("yippee")
