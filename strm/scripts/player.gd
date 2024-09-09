extends CharacterBody2D


const MAX_SPEED = 200;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ParryBox.area_entered.connect(on_parry_box_entered)
	$HealthComponent.dead.connect(on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction*MAX_SPEED
	move_and_slide()
	


func get_movement_vector():
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func on_parry_box_entered(other_area:Area2D):
	var colliding_laser = other_area.get_parent() as Laser
	if colliding_laser == null:
		return
	$HealthComponent.take_damage(colliding_laser.damage);
		


func on_death():
	print("player dead")
	queue_free();
	get_tree().quit();
