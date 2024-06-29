extends Area2D

var tradeOption

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var tower = tradeOption.towerOption
		tower.damage += tradeOption.stats[0]
		tower.CDR += tradeOption.stats[1]
		tower.range += tradeOption.stats[2]
		GameState.currentWaveState = GameState.WaveState.GAME_START
