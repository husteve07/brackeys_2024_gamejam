extends TextureProgressBar

var player:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = 100
	player = get_tree().get_nodes_in_group("player")[0]
	player.get_node("HealthComponent").update_health.connect(update)

func update(percentage: float):
	value = percentage
