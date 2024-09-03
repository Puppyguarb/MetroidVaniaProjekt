extends MeshInstance3D
const Spitter = preload("res://spittah.tscn")
@onready var dir = $"Direction Facing".global_position - global_position
