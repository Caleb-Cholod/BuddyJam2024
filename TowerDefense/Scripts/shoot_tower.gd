extends Node2D


@onready var TowerRange = self.get_meta("Range")
@onready var RangeArea2D = self.get_node("Area2D")
@onready var RangeCS2D = RangeArea2D.get_node("CollisionShape2D")
@onready var Sprite = self.get_node("Sprite2D")
@onready var ShootPoint = Sprite.get_node("ShootPoint")
@onready var projectile = load("res://Scenes/Object Scenes/tower_projectile.tscn")

var TrackedEnemy
var Tracking = false
var EnemiesInRange = 0
var OffCD = true
var CD = 1

func _ready():
	RangeCS2D.shape.radius = TowerRange

func RangeEntered(area):
	if area.get_meta("AreaType") == "Hitbox":
		var EnteredObject = area.get_parent()
		print("Range entered, ", EnteredObject)
		if EnteredObject.get_meta("ObjectType") == "Enemy":
			print("EnemyFound")
			EnemiesInRange += 1
			TrackedEnemy = EnteredObject
			Tracking = true

func RangeExited(area):
	if area.get_meta("AreaType") == "Hitbox" and area.get_parent().get_meta("ObjectType") == "Enemy":
		EnemiesInRange -= 1
		if EnemiesInRange == 0:
			Tracking = false

func _physics_process(delta):
	if Tracking == true:
		self.look_at(TrackedEnemy.global_position)
		#if OffCD == true:
			#Shoot()

func Shoot():
	var instance = projectile.instantiate()
	self.get_parent().add_child(instance)
	instance.set_meta("TargetName", TrackedEnemy.name)

