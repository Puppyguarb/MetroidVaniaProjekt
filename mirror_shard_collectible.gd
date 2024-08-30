extends Node3D

class_name MirrorShardCollectible

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	body.increase_mirror_shard_max()
	self.queue_free()
