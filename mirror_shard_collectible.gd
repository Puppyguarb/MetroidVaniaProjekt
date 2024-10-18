extends Node3D

class_name MirrorShardCollectible

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != VariableManager.player:
		return
	body.increase_mirror_shard_max(100)
	body.max_hp = 100
	body.current_hp = 100
	self.queue_free()
