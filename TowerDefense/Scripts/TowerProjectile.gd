extends CharacterBody2D

var Target
var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#Target = self.get_parent().get_node("Enemies").get_node(str(nameT))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Target:
		var direction = global_position.direction_to(Target.global_position)
		velocity = direction * speed
		move_and_slide()
		
		#if(col.get_collider().is_in_group("enemies")):
		#	print("Hit")
		#	queue_free()
		
	
	#If bullet has existed for a few seconds we should destroy it


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		print("Hit")
		queue_free()
