extends Node2D

var movement_speed: float = 50.0
@onready var agent: LaserShooter = $".."
@onready var navigator: NavigationAgent2D = $NavigationAgent2D
var player:Node2D

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	navigator.path_desired_distance = 4.0
	navigator.target_desired_distance = 4.0
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	var position = agent.position
	navigator.target_position = player.global_position

func _physics_process(delta):
	if navigator.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigator.get_next_path_position()
	#agent.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	if navigator.avoidance_enabled:
		navigator.set_velocity(current_agent_position.direction_to(next_path_position) * movement_speed)
	else:
		_on_navigation_agent_2d_velocity_computed(current_agent_position.direction_to(next_path_position) * movement_speed)
	agent.move_and_slide()
	
func _on_path_find_time_timeout() -> void:
	
	navigator.target_position = player.global_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	agent.velocity = safe_velocity
