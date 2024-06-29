extends Area2D

@onready var place = self.get_parent().get_parent().get_node("AudioSources/Place")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and GameState.isPlacingTower and self.get_child_count() == 1:
		var tower = GameState.towerInventory[GameState.selectedTower]
		tower.global_position = self.global_position
		# tower.reparent(self)
		tower.visible = true
		GameState.isPlacingTower = false
		
		place.play()

