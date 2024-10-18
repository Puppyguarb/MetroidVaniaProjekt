extends Label

func _on_character_body_3d_health_change() -> void:
	self.text = "Hp: " + str(VariableManager.player.current_hp) + "/" + str(VariableManager.player.max_hp)
