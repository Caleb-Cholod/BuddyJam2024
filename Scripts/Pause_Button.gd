extends Button

var normTexture: Texture2D = preload("res://ui/game/game_pause_button.png")
var hoverTexture: Texture2D = preload("res://ui/game/game_pause_button_hover.png")

var state = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if(state == 0):
		get_tree().paused = true  
		state = 1
	else:
		get_tree().paused = false  
		state = 0


func _on_mouse_entered():
	icon = hoverTexture


func _on_mouse_exited():
	icon = normTexture
