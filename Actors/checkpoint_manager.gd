extends Node
class_name CheckPointManager
var checkpoints = []

func _ready() -> void:
	Singleton.checkpoint_manager = self
	checkpoints.insert(0,Vector3(0,0,0))

func add_checkpoint(position):
	if checkpoints[0] == position:
		return
	checkpoints.insert(0,position)
	checkpoints.remove_at(6)
	print("CHOITS",checkpoints)

func get_last_checkpoint():
	if checkpoints.size == 0:
		return

func spiderman_whyd_you_kill_that_guy():
	pass
