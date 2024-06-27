extends Area2D

var tower

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GameState.isPlacingTower = true
		GameState.selectedTower = tower
