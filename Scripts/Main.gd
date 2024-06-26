extends Node2D

# Declare your game state variables
var player_health: int = 100
var towers: Array = []

# Singleton instance
static var instance: Main

func _ready():
	# Set the singleton instance
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
