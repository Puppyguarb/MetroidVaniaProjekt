extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Singleton.player.global_position - global_position
	global_rotation.y = atan2(dir.x,dir.z)


func _on_area_3d_body_entered(body):
	if body is not Player:
		return
	
	Singleton.player.take_damage(420)
