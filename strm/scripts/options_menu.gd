extends Control
@onready var musicslider: HSlider = $MarginContainer/VBoxContainer/GridContainer/musicslider
@onready var sfxslider: HSlider = $MarginContainer/VBoxContainer/GridContainer/sfxslider
@onready var button: Button = $MarginContainer/VBoxContainer/GridContainer/Button


func _ready():

	musicslider.connect("value_changed", Callable(self, "_on_music_volume_changed"))
	sfxslider.connect("value_changed", Callable(self, "_on_sfx_volume_changed"))
	button.connect("pressed", Callable(self, "_on_back_button_pressed"))


func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
