extends Node

#*****************<Health signals>*******************
signal update_health(current_health_percentage: float)
signal dead
#*****************</Health signals>********************

#Health component attributes
@export var current_health = 100
@export var max_health = 100

# takes Damage
# Input: damage taken: int
# desc: upon player taking damage, update_health signal is fired containign the new 
# 		Health percentage for UI update, if the player is dead(current_health == 0)
#		then the dead signal is also fired
func take_damage(damage: int):
	#update UI 
	current_health = clampi(current_health  - damage, 0, max_health)
	update_health.emit(current_health);
	print("current Health: " + str(current_health))
	if current_health == 0:
		dead.emit();
