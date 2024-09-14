extends Node2D

var movement_speed: float = 50.0
@onready var agent: LaserShooter = $".."
@onready var navigator: NavigationAgent2D = $NavigationAgent2D
@onready var search_radius: Area2D = $"../SearchRadius"
@onready var search_timer: Timer = $"../SearchRadius/SearchTimer"

@export var wander_radius:float = 200.0
@export var detect_radius:int = 30

var player:Node2D
var visionflag:int = 0
var original_position = Vector2.ZERO
var new_position = Vector2.ZERO
var rand = RandomNumberGenerator.new()

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	navigator.path_desired_distance = 4.0
	navigator.target_desired_distance = 4.0
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	var position = agent.position
	original_position = position
	new_position = original_position + Vector2(randf_range(-wander_radius, wander_radius), randf_range(-wander_radius,wander_radius))

func _physics_process(delta):
	if navigator.is_navigation_finished():
		new_position = original_position + Vector2(randf_range(-wander_radius, wander_radius), randf_range(-wander_radius,wander_radius))

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigator.get_next_path_position()
	#agent.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	if navigator.avoidance_enabled:
		navigator.set_velocity(current_agent_position.direction_to(next_path_position) * movement_speed)
	else:
		_on_navigation_agent_2d_velocity_computed(current_agent_position.direction_to(next_path_position) * movement_speed)
	agent.move_and_slide()

func _on_path_find_time_timeout() -> void:
	if visionflag == 1:
		navigator.target_position = player.global_position
	else:
		navigator.target_position = new_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	agent.velocity = safe_velocity

func _on_search_radius_body_entered(body: Node2D) -> void:
	if body == player:
		visionflag = 1
		if !search_timer.is_stopped():
			search_timer.stop()
		
func _on_search_radius_body_exited(body: Node2D) -> void:
	if body == player:
		search_timer.start()

func _on_search_timer_timeout() -> void:
	visionflag = 0
	new_position = original_position + Vector2(randf_range(-wander_radius, wander_radius), randf_range(-wander_radius,wander_radius))
