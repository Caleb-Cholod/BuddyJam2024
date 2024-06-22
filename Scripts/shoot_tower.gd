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
var lastDeletedEnemy
#var OffCD = true
var CD = 0.3
var timer = 0
var damage = 2

var enemiesInArea = []

func _ready():
	RangeCS2D.shape.radius = TowerRange

func RangeEntered(area):
	#Currently, tower only shoots most recent enemy that entered area, we want it to always shoot furthest
	if area.get_meta("AreaType") == "Hitbox":
		var EnteredObject = area.get_parent()
		#print("Range entered, ", EnteredObject)
		if EnteredObject.get_meta("ObjectType") == "Enemy":
			EnemiesInRange += 1
			#Add enemyinarea to end of array
			enemiesInArea.append(EnteredObject)
			TrackedEnemy = enemiesInArea[0]
			Tracking = true

func RangeExited(area):
	if area.get_meta("AreaType") == "Hitbox" and area.get_parent().get_meta("ObjectType") == "Enemy":
		#Keep track of last enemy deleted
		if(enemiesInArea.size() >= 1 && area.get_parent() != lastDeletedEnemy):
			lastDeletedEnemy = enemiesInArea[0]
			EnemiesInRange -= 1
			enemiesInArea.pop_front()
		
		if EnemiesInRange == 0:
			Tracking = false


func EnemyinRangeDied(enemy):
	
	#Check if enemy = last enemy killed so that we dont lose an enemy from range, kill it, and then mess up our array
	#print(enemy, " vs ", lastDeletedEnemy)
	TrackedEnemy = null
	if(enemy != lastDeletedEnemy):
		#print(enemy, " has died")
		lastDeletedEnemy = enemy
		EnemiesInRange -= 1
		enemiesInArea.pop_front()


func _physics_process(delta):
	#Check if enemy is dead that we were tracking, this might be unoptimal with several towers 
	#so it might have to be moved to its own seperate post-shoot() function in the future
	if TrackedEnemy == null:
		Tracking = false
	
	if(enemiesInArea.size() > 0):
		TrackedEnemy = enemiesInArea[0]
	
	if Tracking == true:
		TrackedEnemy = enemiesInArea[0]
		self.look_at(TrackedEnemy.global_position)
		
		#shooting cooldown	
		timer += delta
		if(timer >= CD):
			timer = 0
			Shoot()

func Shoot():
	var instance = projectile.instantiate()
	instance.position = position
	instance.projDmg = damage
	#Because we instantiated before changing metadata, the _start was unable to find enemyname.
	#This directly just passes in enemy object into our bullets target variable
	instance.Target = TrackedEnemy
	#Needed for when we have multiple towers
	instance.firedFromTowerNum = 0
	self.get_parent().get_parent().add_child(instance)

