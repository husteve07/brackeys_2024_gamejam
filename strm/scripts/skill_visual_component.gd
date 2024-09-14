extends Node2D

@onready var player: Player = $".."
@onready var skill_buffer: Sprite2D = $SkillBuffer

func _ready() -> void:
	skill_buffer.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.skill_buffer != []:
		skill_buffer.visible = true
		if player.skill_buffer == ["blue"]:
			skill_buffer.frame = 0
		if player.skill_buffer == ["blue", "blue"]:
			skill_buffer.frame = 1
		if player.skill_buffer == ["blue", "red"]:
			skill_buffer.frame = 5
		if player.skill_buffer == ["red"]:
			skill_buffer.frame = 2
		if player.skill_buffer == ["red", "red"]:
			skill_buffer.frame = 3
		if player.skill_buffer == ["red", "blue"]:
			skill_buffer.frame = 4
	else:
		skill_buffer.visible = false
