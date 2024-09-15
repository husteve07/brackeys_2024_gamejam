extends Control
@onready var start_button: Button = $Sprite2D/VBoxContainer/StartButton
@onready var options_button_2: Button = $Sprite2D/VBoxContainer/OptionsButton2
@onready var quit_button_3: Button = $Sprite2D/VBoxContainer/QuitButton3


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect button signals
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	options_button_2.connect("pressed", Callable(self, "_on_options_button_pressed"))
	quit_button_3.connect("pressed", Callable(self, "_on_quit_button_pressed"))


# Function to handle Start button press
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	pass

# Function to handle Options button press
func _on_options_button_pressed():

	get_tree().change_scene_to_file("res://scenes/UI/options_menu.tscn")
	pass

# Function to handle Quit button press
func _on_quit_button_pressed():
	get_tree().quit()
