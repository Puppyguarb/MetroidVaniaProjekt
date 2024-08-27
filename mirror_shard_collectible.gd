extends Node3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.mirror_shards_max > 0:
		return
	body.mirror_shards_max = body.mirror_shards_max + 1
	body.mirror_shards_current = body.mirror_shards_max
	print("mirrors shards increased to ",body.mirror_shards_max)
	self.queue_free()
