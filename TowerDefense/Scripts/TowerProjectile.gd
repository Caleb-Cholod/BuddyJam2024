extends CharacterBody2D

@onready var TargetName = self.get_meta("TargetName")
var Target
var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	Target = self.get_parent().get_node("Enemies").get_node(str(TargetName))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Target:
		var direction = global_position.direction_to(Target.global_position)
		velocity = direction * speed
		move_and_slide()
