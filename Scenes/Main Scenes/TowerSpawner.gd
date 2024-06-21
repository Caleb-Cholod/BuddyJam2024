extends Node2D

@export var basic_tower :PackedScene 
var mousecooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	mousecooldown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousecooldown += delta
	if mousecooldown > 1:
		if Input.is_action_pressed("Spawn_Tower"):
			mousecooldown = 0
			var temp = basic_tower.instantiate()
			temp.global_position = get_global_mouse_position()
			get_parent().get_node("Towers").add_child(temp)
		
