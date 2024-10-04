extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		#Singleton.recent_checkpoint = global_position
		#Vector3(self.global_position.x,self.global_position.y,self.global_position.z)
		#print("CHECKPPOIT",Singleton.recent_checkpoint)
		Singleton.checkpoint_manager.add_checkpoint(global_position)
