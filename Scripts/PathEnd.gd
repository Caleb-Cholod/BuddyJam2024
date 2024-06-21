extends Node2D

@onready var HealthText = self.get_parent().get_node("HealthText")
var MaxHealth = 10
var Health = MaxHealth

func AreaEntered(area):
	if area.get_meta("AreaType") == "Movement" and area.get_parent().get_meta("ObjectType") == "Enemy":
		var Damage = area.get_parent().get_meta("Damage")
		area.get_parent().queue_free()
		Health -= Damage
		HealthText.text = str("Health: ", Health, "/", MaxHealth)
