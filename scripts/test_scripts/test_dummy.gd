extends CharacterBody2D
class_name testDummy

@export var stats: Stats

@onready var nav: NavigationAgent2D = $NavigationAgent2D
var target: Node2D

func _ready() -> void:
	SignalBus.connect("dead",Callable(self, "on_dead"))
	
	nav.path_desired_distance = 1
	nav.target_desired_distance = 1

func on_dead(nam: String) -> void:
	if get_tree().get_first_node_in_group("enemy").name == nam:
		velocity = Vector2.ZERO
		stats.isDead = true
		print("dead")
		#play death animation
		#queue_free()
	else:
		return

func _physics_process(delta: float) -> void:
	
	#TODO Make navigation its own object to drag and drop on enemies!
	if nav.is_navigation_finished() or stats.isDead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if target != null and is_instance_valid(target):
		nav.set_target_position(target.global_position)
	#get position to next node
	var next_pos: Vector2 = nav.get_next_path_position()
	#calc direction
	var direction: Vector2 = (next_pos - global_position).normalized()
	#set velocity and move
	velocity = velocity.lerp((direction).normalized() * stats.speed, stats.acceleration * delta)
	move_and_slide()

func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		nav.set_target_position(body.global_position)

func _on_target_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		nav.set_target_position(global_position)
