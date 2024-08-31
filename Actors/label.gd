extends Label

func _on_character_body_3d_mirror_shard_change() -> void:
	self.text = "shards: " + str(Singleton.player.mirror_shards_current)
	print("yippee")
