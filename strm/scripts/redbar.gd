extends TextureProgressBar

var player:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	player.get_node("CombatComponent").update_red_energy_gauge.connect(update)
	player.get_node("HealthComponent").dead.connect(reset)

func update(energy: int):
	value = energy

func reset():
	value = 0
