extends Node2D
class_name nav

@onready var area_radius: CollisionShape2D = $target_area/CollisionShape2D

@export var radius_detector: float = 250.0 #detection area for radius
@export var stopping_distance: float = 50.0 #distance to stop from player
@export_range(-5.0,5.0) var speed_modifier: float = 1.0

@onready var nave: NavigationAgent2D = $NavigationAgent2D
var target: Node2D

#knockback handling
var is_knockback_active: bool = false
var knockback_timer: Timer
var knockback_velocity: Vector2 = Vector2.ZERO

#for fear
var fear_active: bool = false
var fixed_pos: Vector2

#for blind
var blind_active: bool = false

func _ready() -> void:
	area_radius.shape.radius = radius_detector
	nave.path_desired_distance = 10.0
	nave.target_desired_distance = stopping_distance
	
	#knockback timer
	knockback_timer = Timer.new()
	knockback_timer.one_shot = true
	add_child(knockback_timer)

func apply_knockback(force: Vector2, duration: float = 0.2) -> void:
	is_knockback_active = true
	knockback_velocity = force
	knockback_timer.start(duration)
	await knockback_timer.timeout
	is_knockback_active = false
	knockback_velocity = Vector2.ZERO


func _process(_delta: float) -> void:
	if is_knockback_active:
		return
	
	if target != null and is_instance_valid(target) and fear_active == false and blind_active == false:
		nave.set_target_position(target.global_position)
		fixed_pos = target.global_position
	
	if fear_active:
		var pos: Vector2 = fixed_pos * -1
		nave.set_target_position(pos)
	
	if blind_active:
		nave.set_target_position(fixed_pos) #FIXME make it so they move in circles

func _physics_process(delta: float) -> void:
	if nave.is_navigation_finished() or get_parent().stats.isDead or target == null:
		get_parent().velocity = Vector2.ZERO
		get_parent().move_and_slide()
		return
	
	#handle knockback first
	if is_knockback_active:
		get_parent().velocity = knockback_velocity
		get_parent().move_and_slide()
		return
	
	#get distance to target
	var distance_to_target: float = get_parent().global_position.distance_to(target.global_position)
	
	#if too close stop
	if distance_to_target <= stopping_distance:
		get_parent().velocity = Vector2.ZERO
		get_parent().move_and_slide()
		return
	
	#get position to next node
	var next_pos: Vector2 = nave.get_next_path_position()
	#calc direction
	var direction: Vector2 = (next_pos - get_parent().global_position).normalized()
	
	# Adjust speed based on distance to target (optional for smoother approach)
	var speed: float = get_parent().stats.speed * speed_modifier
	if distance_to_target < stopping_distance * 1.5:
		speed *= (distance_to_target - stopping_distance) / (stopping_distance * 0.5)
	
	#set move
	get_parent().velocity = get_parent().velocity.lerp((direction).normalized() * get_parent().stats.speed, get_parent().stats.acceleration * delta)
	get_parent().move_and_slide()


func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		nave.set_target_position(target.global_position)

func _on_target_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		nave.set_target_position(get_parent().global_position)
