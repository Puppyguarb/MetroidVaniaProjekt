extends Node3D
@onready var body = %StaticBody3D
@onready var mesh = %MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle(true)
	await get_tree().create_timer(2).timeout
	toggle(false)
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func toggle(value):
	mesh.visible = value
	if value:
		body.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		body.process_mode = Node.PROCESS_MODE_DISABLED
	
