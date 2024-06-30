extends Button

var normTexture: Texture2D = preload("res://ui/title screen/title_screen_play_button.png")
var hoverTexture: Texture2D = preload("res://ui/title screen/title_screen_play_button.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	#print("changing scene")
	get_tree().change_scene_to_file("res://Scenes/Main Scenes/level.tscn")

	
func _on_mouse_entered():
	icon = hoverTexture


func _on_mouse_exited():
	icon = normTexture
