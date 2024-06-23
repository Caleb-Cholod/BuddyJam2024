extends Node2D

@export var basic_enemy :PackedScene 
@export var small_enemy :PackedScene 

@onready var Wavetxt = get_parent().get_node("WaveText")
@onready var limitTxt = get_parent().get_node("TowerLimitText")
@onready var TSpawner = get_parent().get_node("TowerSpawner")


var towerLimit = 1

var enemy

var timer
var SpawningCD = 2

var waveNumber = 0
var enemiesInWave = 5
var enemiesSpawned = 0
var enemiesInWaveKilled = 0

var timer5 = 5

var waveInProgress = true

#==WAVES===================
var spawns = []
var wave1 = []
var wave2 = []
var wave3 = []
var wave4 = []
var wave5 = []


var rng
var random1
# Called when the node enters the scene tree for the first time.
func _ready():
	#setup wave spawning
	wave1 = [100, 0]
	wave2 = [70, 30]
	wave3 = [60, 40]
	wave4 = [50, 50]
	wave5 = [40, 60]
	spawns.append(wave1)
	spawns.append(wave2)
	spawns.append(wave3)
	spawns.append(wave4)
	spawns.append(wave5)
	
	#Setup Random
	timer = 0
	rng = RandomNumberGenerator.new()
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(enemiesSpawned < enemiesInWave):
		if(timer > SpawningCD):
			Wavetxt.visible = false
			timer = 0
			enemiesSpawned+=1
			
			random1 = rng.randi() % 100
			if(random1 < spawns[waveNumber][0]):
				enemy = basic_enemy.instantiate()
			else:
				enemy = small_enemy.instantiate()

			enemy.global_position = global_position
			get_parent().get_node("Enemies").add_child(enemy)
	
	#If Wave is finished
	if(enemiesInWaveKilled >= enemiesInWave):
		Wavetxt.visible = true
		#if(waveNumber != 0):
		Wavetxt.text = "Wave " + str(waveNumber+2)
		
		
		
		timer5 -= delta
		if(timer5 < 0):
			#add stats
			
			#reset wave
			waveNumber += 1
			if(waveNumber == 2):
				towerLimit += 1
				print("updating")
				limitTxt.text = "Towers " + str(TSpawner.numberCurrentTowers) + "/" +str(towerLimit)
				TSpawner.towerLimit = towerLimit
				
			enemiesInWave += 1
			enemiesSpawned = 0
			enemiesInWaveKilled = 0
			timer5 = 5
			#
			Wavetxt.visible = false
		
		#here we would initiate a trade and wait rather than do a timer--
		
		
		
