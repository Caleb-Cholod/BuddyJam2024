extends Node2D

var basic_enemy :PackedScene = preload("res://Scenes/Objects/basic_enemy.tscn")
var small_enemy :PackedScene = preload("res://Scenes/Objects/small_enemy.tscn")
var tower: PackedScene = preload("res://Scenes/Objects/Tower.tscn")

var mushroomTexture: Texture2D = preload("res://Sprites/Mushroom/Shroom.png")
var slimeTexture: Texture2D = preload("res://Sprites/Slime/Slime.png")
var bunnyTexture: Texture2D = preload("res://Sprites/Bunny/Bunny.png")
var phoenixTexture: Texture2D = preload("res://Sprites/Phoenix/Phoenix.png")


var Wavetxt: Node
var limitTxt: Node
var TSpawner: Node
var Trader: Node
var Spawner: Node
var Enemies: Node
var InventoryContainer: Node
var TradeContainer: Node

var wave1 = []
var wave2 = []
var wave3 = []
var wave4 = []
var wave5 = []

func _ready():
	var tower1 = tower.instantiate()
	tower1.type = Enums.TowerType.SLIME
	tower1.visible = false
	var tower2 = tower.instantiate()
	tower2.type = Enums.TowerType.BUNNY
	tower2.visible = false
	var tower3 = tower.instantiate()
	tower3.type = Enums.TowerType.MUSHROOM
	tower3.visible = false
	var tower4 = tower.instantiate()
	tower4.type = Enums.TowerType.PHOENIX
	tower4.visible = false
	
	self.add_child(tower1)
	self.add_child(tower2)
	self.add_child(tower3)
	self.add_child(tower4)
	
	GameState.towerInventory.append_array([tower1, tower2, tower3, tower4])
	#setup wave spawning
	wave1 = [100, 0]
	wave2 = [70, 30]
	wave3 = [60, 40]
	wave4 = [50, 50]
	wave5 = [40, 60]
	GameState.spawns.append(wave1)
	GameState.spawns.append(wave2)
	GameState.spawns.append(wave3)
	GameState.spawns.append(wave4)
	GameState.spawns.append(wave5)
	
	#Setup Random
	GameState.timer = 0
	GameState.rng = RandomNumberGenerator.new()
	GameState.rng.randomize()
	GameState.currentWaveState = GameState.WaveState.GAME_START
	Wavetxt = get_parent().get_node("WaveText")
	limitTxt = get_parent().get_node("TowerLimitText")
	TSpawner = get_parent().get_node("TowerSpawner")
	Trader = get_parent().get_node("Trader")
	Spawner = get_parent().get_node("Spawner")
	Enemies = get_parent().get_node("Enemies")
	InventoryContainer = get_parent().get_node("InventoryContainer")
	InventoryContainer.visible = false
	TradeContainer = get_parent().get_node("TradeContainer")
	TradeContainer.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GameState.timer += delta
	
	match GameState.currentWaveState:
		GameState.WaveState.IN_PROGRESS:
			Wavetxt.visible = false
			InventoryContainer.visible = false
			TradeContainer.visible = false
			if(GameState.timer > GameState.SpawningCD && GameState.enemiesSpawned < GameState.enemiesInWave):
				GameState.timer = 0
				GameState.enemiesSpawned+=1
				
				GameState.random1 = GameState.rng.randi() % 100
				var enemy
				if(GameState.random1 < GameState.spawns[GameState.waveNumber][0]):
					enemy = basic_enemy.instantiate()
				else:
					enemy = small_enemy.instantiate()

				enemy.global_position = Spawner.global_position
				Enemies.add_child(enemy)
		GameState.WaveState.GAME_START:
			Wavetxt.visible = true
			Wavetxt.text = "Wave " + str(GameState.waveNumber+1)
			GameState.timer5 -= delta
			if(GameState.timer5 < 0):
				#reset wave
				GameState.waveNumber += 1
				GameState.enemiesInWave += 1
				GameState.enemiesSpawned = 0
				GameState.enemiesInWaveKilled = 0
				GameState.timer5 = 5
				Wavetxt.visible = false
				GameState.currentWaveState = GameState.WaveState.PLANNING
		GameState.WaveState.PLANNING:
			for i in range(4):
				if (GameState.towerInventory[i] != null):
					match GameState.towerInventory[i].type:
						Enums.TowerType.MUSHROOM:
							InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).texture = mushroomTexture
						Enums.TowerType.SLIME:
							InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).texture = slimeTexture
						Enums.TowerType.BUNNY:
							InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).texture = bunnyTexture
						Enums.TowerType.PHOENIX:
							InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).texture = phoenixTexture
					InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(1).get_child(0).tower = i
					InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).visible = true
				else:
					InventoryContainer.get_child(0).get_child(0).get_child(i).get_child(0).visible = false
			InventoryContainer.visible = !GameState.isPlacingTower
		GameState.WaveState.TRADING:
			TradeContainer.visible = true
			
	#If Wave is finished
	if(GameState.enemiesInWaveKilled >= GameState.enemiesInWave):
		GameState.currentWaveState = GameState.WaveState.TRADING
