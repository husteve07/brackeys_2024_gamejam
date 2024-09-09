extends Node2D

# Preload the red and purple laser scenes
var RedLaserScene = preload("res://scenes/Lasers/red_laser.tscn")
var PurpleLaserScene = preload("res://scenes/Lasers/blue_laser.tscn")

func _ready():
	#Spawn a laser every 2 seconds
	var laser_spawn_timer = Timer.new()
	laser_spawn_timer.wait_time = 2.0
	laser_spawn_timer.connect("timeout", Callable(self, "_spawn_laser"))
	add_child(laser_spawn_timer)
	laser_spawn_timer.start()

func _spawn_laser():
	# Get the player node
	var player = get_tree().get_nodes_in_group("player")[0]
	
	if player:
		# Calculate the direction to the player
		var direction = (player.position - position).normalized()

		# Randomly choose between red and purple laser
		var laser_instance
		if randi() % 2 == 0:
			laser_instance = RedLaserScene.instantiate()
		else:
			laser_instance = PurpleLaserScene.instantiate()
		
		# Set position and direction
		laser_instance.position = position  # Set position to enemy's position
		laser_instance.direction = direction  # Set the direction towards the player
		
		# Add the laser to the scene tree
		get_parent().add_child(laser_instance)
