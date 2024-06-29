extends Node2D

var mushroomTexture: Texture2D = preload("res://Sprites/Towers/Tree_Stump_Shroom.png")
var slimeTexture: Texture2D = preload("res://Sprites/Towers/Tree_Stump_Slime.png")
var bunnyTexture: Texture2D = preload("res://Sprites/Towers/Tree_Stump_Bunny.png")
var phoenixTexture: Texture2D = preload("res://Sprites/Towers/Tree_Stump_Phoenix.png")

#@onready var TowerRange = self.get_meta("Range")
@onready var RangeArea2D = self.get_node("Area2D")
@onready var RangeCS2D = RangeArea2D.get_node("CollisionShape2D")
@onready var Sprite = self.get_node("Sprite2D")
@onready var ShootPoint = Sprite.get_node("ShootPoint")
@onready var projectile = load("res://Scenes/Objects/tower_projectile.tscn")


@onready var SlSlime = self.get_parent().get_parent().get_node("AudioSources/SlimeShoot")
@onready var PhSlime = self.get_parent().get_parent().get_node("AudioSources/PheonixShoot")
@onready var MuSlime = self.get_parent().get_parent().get_node("AudioSources/MushroomShoot")
@onready var BuSlime = self.get_parent().get_parent().get_node("AudioSources/BunnyShoot")

var TrackedEnemy
var Tracking = false
var EnemiesInRange = 0
var lastDeletedEnemy
#var OffCD = true
var CDR = 0
var CD = 0.7 - (CDR / 100)
var timer = 0
var damage = 2
var range = 150
var isEnabled = false
var type: Enums.TowerType

var enemiesInArea = []

func _ready():
	RangeCS2D.shape.radius = range
	match type:
		Enums.TowerType.BUNNY:
			Sprite.texture = bunnyTexture
		Enums.TowerType.SLIME:
			Sprite.texture = slimeTexture
		Enums.TowerType.MUSHROOM:
			Sprite.texture = mushroomTexture
		Enums.TowerType.PHOENIX:
			Sprite.texture = phoenixTexture

func RangeEntered(area):
	#just update our range here
	RangeCS2D.shape.radius = range
	
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
	
	if Tracking == true && enemiesInArea.size() > 0:
		TrackedEnemy = enemiesInArea[0]
		if TrackedEnemy != null:	#sanity check for weird enemy existing error
			self.get_child(0).set_flip_h(self.global_position.x < abs(TrackedEnemy.global_position.x))
		
		#shooting cooldown	
		timer += delta
		if(timer >= CD):
			timer = 0
			Shoot()

func Shoot():
	#Choose which sound to play
	match type:
		Enums.TowerType.BUNNY:
			BuSlime.play()
		Enums.TowerType.SLIME:
			SlSlime.play()
		Enums.TowerType.MUSHROOM:
			MuSlime.play()
		Enums.TowerType.PHOENIX:
			PhSlime.play()
			
			
	var instance = projectile.instantiate()
	instance.position = position
	instance.projDmg = damage
	#Because we instantiated before changing metadata, the _start was unable to find enemyname.
	#This directly just passes in enemy object into our bullets target variable
	instance.Target = TrackedEnemy
	#Needed for when we have multiple towers
	instance.firedFromTowerNum = 0
	self.get_parent().get_parent().add_child(instance)
	
	

