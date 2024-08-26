extends Node3D

const GREEN_MAT = preload("res://Materials/Green.tres")
const CUBE_SCENE = preload("res://test_cube.tscn")

signal on_blink()

@onready
var blue_cube = $%BlueCube
@onready
var cube_mat = blue_cube.material_override
var can_color_shift = 7
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	$SpawnBox.connect("timeout",_on_spawn_box_timeout)
	#spawned_cube.position.y = 1.5
	#get_child(get_child_count()).position.y = 1.5
	#await (get_tree().create_timer(5.0).timeout)
	#can_color_shift = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(delta)
	time += delta
	#print (time)
	blue_cube.position.z -= 0.5
	
	
	
	
	# Hello I am a comment
	# Hi rose
	#if not can_color_shift: # not can_color_shift
	#	return
	#print("Ding")
	
	#var new_color = Color(randf(),randf(),randf(),1)
	#blue_cube.material_override.albedo_color = new_color
	#GREEN_MAT.albedo_color = new_color


func _on_spawn_box_timeout():
	pass
	#add_child(CUBE_SCENE.instantiate())


func _on_area_3d_body_entered(body):
	add_child(CUBE_SCENE.instantiate())
