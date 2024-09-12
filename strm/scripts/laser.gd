extends Node2D
class_name Laser
# Velocity of the laser
@export var speed = 350
@export var laser_name = "laser"
@export var damage = 0

var direction = Vector2.ZERO

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered_player)
	
# possible refactory
#if the laser collides with player, destroy laser
func on_area_entered_player(other_area:Area2D):
	if !other_area.get_collision_layer_value(1):
		return
	queue_free()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
		
func _process(delta):
	position += direction * speed * delta

	# Destroy the laser when it goes off-screen or out of bounds
	#if position.x < 0 or position.x > get_viewport_rect().size.x or position.y < 0 or position.y > get_viewport_rect().size.y:
		#queue_free()

#*****************<helper functions>*****************
func get_laser_name():
	return laser_name
	

func get_laser_damage():
	return damage
#*****************</helper functions>*****************
