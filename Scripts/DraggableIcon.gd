extends Area2D

var tower
@onready var pick = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AudioSources/Pick")

#Sprites
@onready var n1: Texture2D = preload("res://ui/icons/icon_tower_slime.png")
@onready var h1: Texture2D = preload("res://ui/icons/icon_tower_slime_hover.png")

@onready var n2: Texture2D = preload("res://ui/icons/icon_tower_bunny.png")
@onready var h2: Texture2D = preload("res://ui/icons/icon_tower_bunny_hover.png")

@onready var n3: Texture2D = preload("res://ui/icons/icon_tower_mushroom.png")
@onready var h3: Texture2D = preload("res://ui/icons/icon_tower_mushroom_hover.png")

@onready var n4: Texture2D = preload("res://ui/icons/icon_tower_phoenix.png")
@onready var h4: Texture2D = preload("res://ui/icons/icon_tower_phoenix_hover.png")



@onready var i = get_meta("index")
@onready var img = get_parent().get_parent().get_node("TowerIcon")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GameState.isPlacingTower = true
		GameState.selectedTower = tower
		
		pick.play()


func _on_mouse_shape_entered(shape_idx):
	i = get_meta("index")
	img = get_parent().get_parent().get_node("TowerIcon")
	print(get_meta("index"))
	print(i)
	match i:
		0:
			img.texture = h1
		1:
			img.texture = h2
		2:
			img.texture = h3
		3:
			img.texture = h4


func _on_mouse_shape_exited(shape_idx):
	i = get_meta("index")
	img = get_parent().get_parent().get_node("TowerIcon")
	match i:
		0:
			img.texture = n1
		1:
			img.texture = n2
		2:
			img.texture = n3
		3:
			img.texture = n4
