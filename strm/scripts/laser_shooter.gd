extends CharacterBody2D
class_name LaserShooter

@export var firing_time_interval = 2.0

# Preload the red and purple laser scenes
var RedLaserScene = preload("res://scenes/Lasers/red_laser.tscn")
var BlueLaserScene = preload("res://scenes/Lasers/blue_laser.tscn")

func _ready():
	#Spawn a laser every 2 seconds
	var laser_spawn_timer = Timer.new()
	laser_spawn_timer.wait_time = firing_time_interval
	laser_spawn_timer.connect("timeout", Callable(self, "spawn_laser"))
	add_child(laser_spawn_timer)
	laser_spawn_timer.start()

func _physics_process(delta):
	velocity.x += 1
	move_and_slide()

#desc: aquires player location and fires laser towards it
func spawn_laser():
	# Get the player node
	var player = get_tree().get_nodes_in_group("player")[0]
	
	if player:
		# Calculate the direction to the player
		var direction = (player.position - position).normalized()

		var laser_instance = choose_laser_type();
		if laser_instance == null:
			return
		
		# Set position and direction
		laser_instance.position = position + (4*direction)
		laser_instance.direction = direction  
		
		# Add the laser to the scene tree
		get_parent().add_child(laser_instance)


func choose_laser_type() -> Laser:
	# Randomly choose between red and blue laser
	if randi() % 2 == 0:
		return RedLaserScene.instantiate()
	else:
		return BlueLaserScene.instantiate()
