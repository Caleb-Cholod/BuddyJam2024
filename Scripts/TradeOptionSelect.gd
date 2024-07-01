extends Area2D

var tradeOption
#Sprites
@onready var n1: Texture2D = preload("res://ui/trade/trade_card_small.png")
@onready var h1: Texture2D = preload("res://ui/trade/trade_card_hover_1.png")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var tower = tradeOption.towerOption
		tower.damage += tradeOption.stats[0]
		tower.CDR += tradeOption.stats[1]
		tower.range += tradeOption.stats[2]
		GameState.currentWaveState = GameState.WaveState.GAME_START


func _on_mouse_shape_entered(shape_idx):
	get_node("TradeCard").texture = h1


func _on_mouse_shape_exited(shape_idx):
	get_node("TradeCard").texture = n1


