extends Node2D

@export var basic_tower :PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Spawn_Tower"):
		print("Mouse")
		var temp = basic_tower.instantiate()
		temp.global_position = get_global_mouse_position()
		get_parent().get_node("Towers").add_child(temp)
		
