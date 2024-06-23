extends Node2D

@export var basic_tower :PackedScene 
@export var red_tower :PackedScene 

@onready var spawner = get_parent().get_node("Spawner")
@onready var TowerLimitTxt = self.get_parent().get_node("TowerLimitText")

var mousecooldown
var towerLimit = 1
var numberCurrentTowers = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	mousecooldown = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousecooldown += delta
	if numberCurrentTowers < towerLimit && mousecooldown > 1:
		
		if Input.is_action_pressed("Spawn_Tower"):
			mousecooldown = 0
			var temp = basic_tower.instantiate()
			temp.global_position = get_global_mouse_position()
			get_parent().get_node("Towers").add_child(temp)
			numberCurrentTowers += 1
			print(numberCurrentTowers)
			TowerLimitTxt.text = "Towers " + str(numberCurrentTowers) + "/" + str(towerLimit)
			
			
		if Input.is_action_pressed("Spawn_Red"):
			mousecooldown = 0
			var temp = red_tower.instantiate()
			temp.global_position = get_global_mouse_position()
			get_parent().get_node("Towers").add_child(temp)
			numberCurrentTowers += 1
			print(numberCurrentTowers)
			TowerLimitTxt.text = "Towers " + str(numberCurrentTowers) + "/" + str(towerLimit)
		
