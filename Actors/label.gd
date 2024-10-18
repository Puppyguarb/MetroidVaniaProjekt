extends Label

func _on_character_body_3d_mirror_shard_change() -> void:
	self.text = "Mirror Shards: " + str(VariableManager.player.mirror_shards_current) + "/" + str(VariableManager.player.mirror_shards_max)
