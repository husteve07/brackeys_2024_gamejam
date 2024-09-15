extends Control
@onready var retry_b_utton: Button = $Sprite2D/RetryBUtton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_b_utton.connect("pressed", Callable(self, "_on_retry_button_pressed"))
	pass # Replace with function body.


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Tutorial.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
