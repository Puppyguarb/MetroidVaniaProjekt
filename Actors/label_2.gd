extends Label

func _on_character_body_3d_health_change() -> void:
	self.text = "Hp: " + str(Singleton.player.current_hp) + "/" + str(Singleton.player.max_hp)
