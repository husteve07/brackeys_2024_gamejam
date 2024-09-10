extends Node2D
class_name Laser
# Velocity of the laser
@export var speed = 400
@export var laser_name = "laser"
@export var damage = 0

var direction = Vector2.ZERO

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered_player)
	

func on_area_entered_player(other_area:Area2D):
	print('collision')
	if !other_area.get_collision_layer_value(1):
		print("not player")
		return
	queue_free()


func _process(delta):
	position += direction * speed * delta

	# Destroy the laser when it goes off-screen or out of bounds
	if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()

func get_laser_name():
	return laser_name
	

func get_laser_damage():
	return damage
