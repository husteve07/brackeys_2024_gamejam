extends LaserShooter

@export var num_of_lasers_to_shoot=20
@export var ccw = true
@export var range_of_spiral_deg = 180

var flag = -1
var external_timer = Timer.new()
var internal_timer = Timer.new()
var total_shooting_time = firing_time_interval - 0.01

var player_position_snapshot = Vector2.ZERO
var current_laser_count = 0

#external timer: every x second the shooter fires
#
#internal timer: y bullets shoots in z seconds with z/y seconds interval
#
#every bullet shoots at 180/y angle with starting angle pointed at the player
#
#External timer ends:
#
	#internal timer starts:
		#
		#at # bullet, fire at 0 + # angle
		#
		#check if its the last bullet, if not
			#increment #
		#else
			#start external timer 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_position = position
	$HitBox.area_entered.connect(on_entered_player_skill)
	$HealthComponent.dead.connect(on_dead);
	player = get_tree().get_nodes_in_group("player")[0]
	player.activated_skill.connect(on_player_time_slow_activated);
	player.get_node("HealthComponent").dead.connect(on_reset)
	var time_interval_between_bullets = total_shooting_time/num_of_lasers_to_shoot
	internal_timer.connect("timeout", Callable(self, "spawn_laser_spiral"))
	internal_timer.wait_time = time_interval_between_bullets;
	add_child(internal_timer)

	external_timer.connect("timeout", Callable(self, "reset_shooter"))
	external_timer.wait_time = firing_time_interval
	add_child(external_timer)
	external_timer.start();
	
	set_invincibility_timer()
	
	pass # Replace with function body.


func spawn_laser_spiral():

	var laser_instance = choose_laser_type();
	if laser_instance == null:
		return

	var current_angle = range_of_spiral_deg/num_of_lasers_to_shoot * current_laser_count
	flag *= -1
	#laser_instance.direction = (player_position_snapshot - position).rotated(-deg_to_rad(flag*current_angle)).normalized()
	if(ccw):
		laser_instance.direction = (player_position_snapshot - position).rotated(deg_to_rad(current_angle)).normalized()
	else:
		laser_instance.direction = (player_position_snapshot - position).rotated(deg_to_rad(current_angle)).normalized()

	# Set position and direction
	laser_instance.position = position + (4*laser_instance.direction)  
	
	laser_instance.spawned_while_skill_is_active = is_time_slow_active
	
	# Add the laser to the scene tree
	get_parent().add_child(laser_instance)
	

	current_laser_count += 1;
	if current_laser_count >= num_of_lasers_to_shoot:
		internal_timer.stop()
		current_laser_count = 0;
		external_timer.start()


func reset_shooter():
	var player = get_tree().get_nodes_in_group("player")[0]
	player_position_snapshot = player.position
	internal_timer.start()
	pass

func on_reset():
	external_timer.stop()
	internal_timer.stop()
	position = reset_position
	external_timer.start()
	$HealthComponent.player_restore_health($HealthComponent.max_health)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y > position.y:
		z_index = 0
	else:
		z_index = 2
	if player.position.x > position.x:
		head.scale.x=-1
		body.scale.x=-1
	else:
		head.scale.x = 1
		body.scale.x= 1
