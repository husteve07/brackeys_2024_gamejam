extends Node2D
class_name Skill
@export var skill_name = ""
@export var cool_down_seconds = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_skill_activatable():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
#dummy activate function
func activate():
	print("activating" + get_skill_name())
	return true
	

#helper func
func get_skill_name() -> String:
	return skill_name
