extends CharacterBody2D

var Target
var speed = 1000
var lifetime = 3
var currentTime = 0
var projDmg = 0
var firedFromTowerNum = -1

func _ready():
	pass


func _physics_process(delta):
	currentTime += delta
	if Target != null:
		var direction = global_position.direction_to(Target.global_position)
		velocity = direction * speed
		move_and_slide()
		
		#just do my own collision cuz it works better :/
		var distVect = abs(Target.global_position - global_position)
		if(distVect.x < 50 && distVect.y < 50):
			if Target.is_in_group("enemies"):
				Target.health -= projDmg
				if(Target.health <= 0):
					get_parent().get_node("Main").get_child(firedFromTowerNum).EnemyinRangeDied(Target)
				queue_free()
	#if target is null, just destroy bullet rather than leaving it
	else:
		queue_free()
		
	#If bullet has existed for a few seconds we should destroy it
	if currentTime >= lifetime:
		queue_free()
		
	


