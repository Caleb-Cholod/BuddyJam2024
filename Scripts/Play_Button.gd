extends Button

var normTexture: Texture2D = preload("res://ui/game/game_start_wave_button.png")
var hoverTexture: Texture2D = preload("res://ui/game/game_start_wave_button_hover.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pressed():
	GameState.currentWaveState = GameState.WaveState.IN_PROGRESS
	
func _on_mouse_entered():
	icon = hoverTexture


func _on_mouse_exited():
	icon = normTexture
