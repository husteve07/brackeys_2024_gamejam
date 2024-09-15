extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var anim_tree: AnimationTree = $AnimationTree

var facing:int = 1
var blendflag:int = 1

func _ready() -> void:
	anim_tree.animation_finished.connect(check)
	player.activated_skill.connect(dash)
	
func dash(skill:Skill):
	if skill.get_skill_name() == "Healing_skill":
		anim_tree.set("parameters/Transition/transition_request", "dash")
		blendflag = 0
#Mostly temporary animation tree code
func _process(delta: float) -> void:
	if player.velocity.x > 0:
		facing = 1
	if player.velocity.x < 0:
		facing = -1
	blend(facing)
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		anim_tree.set("parameters/Transition/transition_request", "run")
	if Input.is_action_just_pressed("absorb_laser"):
		blendflag = 0
		anim_tree.set("parameters/Transition 2/transition_request", "shield")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if Input.is_action_just_pressed("blue_skill"):
		blendflag = 0
		anim_tree.set("parameters/Transition 2/transition_request", "skill")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if Input.is_action_just_pressed("red_skill"):
		blendflag = 0
		anim_tree.set("parameters/Transition 2/transition_request", "skill")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if player.velocity==Vector2.ZERO:
		anim_tree.set("parameters/Transition/transition_request", "idle")

func check(anim_name:String):
	blendflag = 1

func blend(facing):
	if blendflag == 1:
		anim_tree.set("parameters/idle/blend_position", facing)
		anim_tree.set("parameters/run/blend_position", facing)
		anim_tree.set("parameters/shield/blend_position", facing)
		anim_tree.set("parameters/skill/blend_position", facing)
		anim_tree.set("parameters/dash/blend_position", facing)
