extends Area2D

var tower
@onready var pick = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AudioSources/Pick")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GameState.isPlacingTower = true
		GameState.selectedTower = tower
		
		pick.play()
