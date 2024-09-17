extends Node3D

const SPIN_RATE = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rotation.y += delta * SPIN_RATE
	rotation.y += delta * SPIN_RATE*randf_range(0,2)
