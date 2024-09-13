extends CharacterBody2D
class_name LaserShooter

@export var firing_time_interval = 2.0
@export var invincible_time = 1.0
@onready var head: AnimatedSprite2D = $Head
@onready var body: AnimatedSprite2D = $Body

# Preload the red and purple laser scenes
var RedLaserScene = preload("res://scenes/Lasers/red_laser.tscn")
var BlueLaserScene = preload("res://scenes/Lasers/blue_laser.tscn")
var player:Node2D
var invincibility_timer : Timer

func _ready():
	#Spawn a laser every 2 seconds
	$HitBox.area_entered.connect(on_entered_player_skill)

	$HealthComponent.dead.connect(on_dead);
	player = get_tree().get_nodes_in_group("player")[0]
	var laser_spawn_timer = Timer.new()
	laser_spawn_timer.wait_time = firing_time_interval
	laser_spawn_timer.connect("timeout", Callable(self, "spawn_laser"))
	add_child(laser_spawn_timer)
	laser_spawn_timer.start()
	

	
	
func set_invincibility_timer():
	invincibility_timer = Timer.new()
	invincibility_timer.wait_time = invincible_time
	invincibility_timer.connect("timeout", Callable(self, "reset_take_damage"))
	invincibility_timer.one_shot = true;
	add_child(invincibility_timer)
	
func reset_take_damage():
	var skill_effects  = []
	if $HitBox.get_overlapping_areas().size() == 0:
		print("enemy left zone")
		return;
	print("enemy still in zone")
	for area in $HitBox.get_overlapping_areas():
		if area.get_parent() as Skill:
			skill_effects.append(area.get_parent())
			
	var damage = 0
	for skill in skill_effects:
		damage += skill.skill_damage
	print(damage)
		
	$HealthComponent.take_damage(damage);
	invincibility_timer.start() 
			

func on_entered_player_skill(other_area: Area2D):
	var player_skill = other_area.get_parent() as Skill;
	if player_skill:
		var damage = other_area.get_parent().skill_damage 
		if damage > 0:
			$HealthComponent.take_damage(other_area.get_parent().skill_damage);
			invincibility_timer.start()


func on_dead():
	#play death animation
	print("enemy death")
	queue_free();
	pass


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

#desc: aquires player location and fires laser towards it
func spawn_laser():
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
