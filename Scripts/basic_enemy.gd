extends CharacterBody2D

@onready var Path = self.get_parent().get_parent().get_node("Path")

var speed = 200  # speed in pixels/sec
var health = 10
var damage = 1


var currentPointNum = 0
var currentPoint
var pointExists = false

func _ready():
	#Set to group enemies
	add_to_group("enemies")
	#Find next point
	GetNewPoint()

func _physics_process(delta):
	if pointExists == true:
		var direction = global_position.direction_to(currentPoint.global_position)
		velocity = direction * speed
		move_and_slide()
		
	#If we died
	if health <= 0:
		queue_free()

func GetNewPoint():
	currentPointNum += 1
	currentPoint = Path.get_node(str("PathPoint", currentPointNum))
	pointExists = true

func PathWalked(area):
	if area.get_meta("AreaType") == "Path" and area.get_parent() == currentPoint:
		pointExists = false
		GetNewPoint()
