extends Node2D

@onready var HealthText = self.get_parent().get_node("HealthText")
var MaxHealth = 10
var Health = MaxHealth
@onready var deathText = self.get_parent().get_node("DeathText")
var isGameOver = false
var timer3 = 0

func AreaEntered(area):
	if area.get_meta("AreaType") == "Movement" and area.get_parent().get_meta("ObjectType") == "Enemy":
		var Damage = area.get_parent().get_meta("Damage")
		area.get_parent().queue_free()
		Health -= Damage
		HealthText.text = str("Health: ", Health, "/", MaxHealth)
		#Update enemies killed
		GameState.enemiesInWaveKilled += 1
		
		if(Health <= 0):
			#If we lose
			print("you died")
			isGameOver = true
			deathText.visible = true

func _process(delta):
	if isGameOver:
		timer3 += delta
		if timer3 > 3:
			timer3 = 0
			isGameOver = false
			deathText.visible = false
			get_tree().change_scene_to_file("res://Scenes/Main Scenes/MainMenu.tscn")
