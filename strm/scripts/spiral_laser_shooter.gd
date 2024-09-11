extends LaserShooter

@export var num_of_lasers_to_shoot=5
@export var ccw = true
@export var range_of_spiral_deg = 180

var external_timer = Timer.new()
var internal_timer = Timer.new()
var total_shooting_time = firing_time_interval - 0.01
var time_interval_between_bullets = total_shooting_time/num_of_lasers_to_shoot
var player_position_snapshot = Vector2.ZERO
var current_laser_count = 0

# Preload the red and purple laser scenes
# var RedLaserScene = preload("res://scenes/Lasers/red_laser.tscn")
# var BlueLaserScene = preload("res://scenes/Lasers/blue_laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	internal_timer.connect("timeout", Callable(self, "spawn_laser_spiral"))
	internal_timer.wait_time = time_interval_between_bullets;
	add_child(internal_timer)

	external_timer.connect("timeout", Callable(self, "reset_shooter"))
	external_timer.wait_time = firing_time_interval
	add_child(external_timer)
	external_timer.start();
	pass # Replace with function body.


func spawn_laser_spiral():

	var laser_instance = choose_laser_type();
	if laser_instance == null:
		return


	print(current_laser_count)
	var current_angle = range_of_spiral_deg/num_of_lasers_to_shoot * current_laser_count
	if(ccw):
		laser_instance.direction = (player_position_snapshot - position).rotated(deg_to_rad(-current_angle)).normalized()
	else:
		laser_instance.direction = (player_position_snapshot - position).rotated(deg_to_rad(current_angle)).normalized()

	# Set position and direction
	laser_instance.position = position  
	
	# Add the laser to the scene tree
	get_parent().add_child(laser_instance)
	

	current_laser_count += 1;
	if current_laser_count >= num_of_lasers_to_shoot:
		internal_timer.stop()
		current_laser_count = 0;
		external_timer.start()


func reset_shooter():
	print('hi')
	var player = get_tree().get_nodes_in_group("player")[0]
	player_position_snapshot = player.position
	internal_timer.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
