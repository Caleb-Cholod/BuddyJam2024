extends Node2D

var tower: PackedScene = preload("res://Scenes/Objects/Tower.tscn")

enum WaveState {
	GAME_START,
	IN_PROGRESS,
	PLANNING,
	TRADING
}

# Declare your game state variables
var player_health: int = 100
var towerInventory: Array = []
var currentWaveState: WaveState = WaveState.GAME_START
var towerLimit = 1
var timer
var SpawningCD = 2
var waveNumber = 0
var enemiesInWave = 5
var enemiesSpawned = 0
var enemiesInWaveKilled = 0
var timer5 = 5
var waveInProgress = true
var isPlacingTower: bool
var selectedTower: int

#==WAVES===================
var spawns = []
var rng
var random1

