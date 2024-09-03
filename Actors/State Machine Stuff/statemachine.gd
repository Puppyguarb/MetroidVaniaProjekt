class_name StateMachine extends Node


signal state_changed(newstate)

var state_machine_owner = "" #this could player or an enemy
#could change to dictionary in future. idk
var states = []


func _ready():
	#assign to default state
	pass


func change_state(newstate):
	emit_signal("state_changed",newstate)
	pass
