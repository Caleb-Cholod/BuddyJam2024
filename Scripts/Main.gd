extends Node2D

var basic_enemy :PackedScene = preload("res://Scenes/Objects/basic_enemy.tscn")
var small_enemy :PackedScene = preload("res://Scenes/Objects/small_enemy.tscn")
var mushroomEnemy :PackedScene = preload("res://Scenes/Objects/mushroom.tscn")
var pheonixEnemy :PackedScene = preload("res://Scenes/Objects/Pheonix.tscn")
var tower: PackedScene = preload("res://Scenes/Objects/Tower.tscn")

var mushroomTexture: Texture2D = preload("res://ui/icons/icon_tower_mushroom.png")
var slimeTexture: Texture2D = preload("res://ui/icons/icon_tower_slime.png")
var bunnyTexture: Texture2D = preload("res://ui/icons/icon_tower_bunny.png")
var phoenixTexture: Texture2D = preload("res://ui/icons/icon_tower_phoenix.png")
var addTexture: Texture2D = preload("res://ui/trade/trade_arrow3.png")
var subTexture: Texture2D = preload("res://ui/trade/trade_arrow2.png")

var Wavetxt: Node
var limitTxt: Node
var deathTxt: Node
var TSpawner: Node
var Trader: Node
var Spawner: Node
var Enemies: Node
var InventoryContainer: Node
var TradeContainer: Node

#Audio====
@onready var popup = self.get_parent().get_node("AudioSources/Popup")

var wave1 = []
var wave2 = []
var wave3 = []
var wave4 = []
var wave5 = []

var tradeOptions = []

var hasOpenedInv = false

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
	deathTxt = get_parent().get_node("DeathText")
	TSpawner = get_parent().get_node("TowerSpawner")
	Trader = get_parent().get_node("Trader")
	Spawner = get_parent().get_node("Spawner")
	Enemies = get_parent().get_node("Enemies")
	InventoryContainer = get_parent().get_node("InventoryContainer")
	InventoryContainer.visible = false
	TradeContainer = get_parent().get_node("TradeContainer")
	TradeContainer.visible = false
	deathTxt.visible = false
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
				if(GameState.random1 < 25):#GameState.spawns[GameState.waveNumber][0]):
					enemy = basic_enemy.instantiate()
					enemy.enemyindex = 0
				elif(GameState.random1 >= 25 && GameState.random1 < 50):
					enemy = small_enemy.instantiate()
					enemy.enemyindex = 1
				elif(GameState.random1 >= 50 && GameState.random1 < 75):
					enemy = mushroomEnemy.instantiate()
					enemy.enemyindex = 2
				else:
					enemy = pheonixEnemy.instantiate()
					enemy.enemyindex = 3

				enemy.global_position = Spawner.global_position
				Enemies.add_child(enemy)
			#If Wave is finished
			if(GameState.enemiesInWaveKilled >= GameState.enemiesInWave):
				tradeOptions = []
				GameState.currentWaveState = GameState.WaveState.TRADING
		GameState.WaveState.GAME_START:
			TradeContainer.visible = false
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
			if(!hasOpenedInv):	
				popup.play()
				hasOpenedInv = true
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
			hasOpenedInv = false
			TradeContainer.visible = true
			if (tradeOptions.size() < 3):
				tradeOptions = generateTrades()
			for y in range(3):
				var trade = TradeContainer.get_child(y+1)
				match(tradeOptions[y].towerOption.type):
					Enums.TowerType.BUNNY:
						trade.get_child(0).get_child(0).texture = bunnyTexture
					Enums.TowerType.MUSHROOM:
						trade.get_child(0).get_child(0).texture = mushroomTexture
					Enums.TowerType.SLIME:
						trade.get_child(0).get_child(0).texture = slimeTexture
					Enums.TowerType.PHOENIX:
						trade.get_child(0).get_child(0).texture = phoenixTexture
				
				trade.tradeOption = tradeOptions[y]
				for x in range(3):
					if (tradeOptions[y].stats[x] >= 0):
						trade.get_child(0).get_child(4 + x).texture = addTexture
					else:
						trade.get_child(0).get_child(4 + x).texture = subTexture
					match (x):
						0:
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text1").text = str(tradeOptions[y].towerOption.damage)
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text2").text = str(tradeOptions[y].stats[x] + tradeOptions[y].towerOption.damage)
						1:
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text1").text = str(tradeOptions[y].towerOption.CDR)
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text2").text = str(tradeOptions[y].stats[x] + tradeOptions[y].towerOption.CDR)
						2:
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text1").text = str(tradeOptions[y].towerOption.range)
							trade.get_child(0).get_node("Stat" + str(x+1) +"Text2").text = str(tradeOptions[y].stats[x] + tradeOptions[y].towerOption.range)


func generateTrades():
	var towerOptions = []
	for i in range(3):
		var dmg = GameState.rng.randi() % 4 - GameState.rng.randi() % 4
		var rate = GameState.rng.randi() % 12 - GameState.rng.randi() % 12
		var range = GameState.rng.randi() % 25 - GameState.rng.randi() % 25
		var randstat = GameState.rng.randi() % 3
		#if stats are all pos or negative, flip a random one (this could be better haha)
		if(dmg >= 0 && rate >= 0 && range >= 0):
			if(randstat == 0):
				dmg = 0 - dmg
			elif(randstat == 1):
				rate = 0 - rate
			else:
				range = 0 - range
				
		elif(dmg <= 0 && rate <= 0 && range <= 0):
			if(randstat == 0):
				dmg = 0 - dmg
			elif(randstat == 1):
				rate = 0 - rate
			else:
				range = 0 - range
				
		#apply stats		
		var stats = [dmg, rate, range]
		var towerOption = GameState.towerInventory.pick_random()
		
		towerOptions.append({ stats = stats, towerOption = towerOption })
		
	return towerOptions
