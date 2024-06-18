extends Node2D

@export var basic_enemy :PackedScene 

var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	#var temp = bullet.instantiate()
	if(timer > 3):
		print("spawning...")
		timer = 0
		var temp = basic_enemy.instantiate()
		
		
		# The randomization at the end is so that way the collisions don't go fucky wucky
		temp.global_position = global_position#elf.global_position + Vector2(randf_range(-2, 2), randf_range(-2, 2))
		get_parent().get_node("Enemies").add_child(temp)
		
