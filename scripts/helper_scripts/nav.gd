extends Node2D
class_name nav

@onready var area_radius: CollisionShape2D = $target_area/CollisionShape2D

@export var radius_detector: float #detection area for radius
@export var stopping_distance: float #distance to stop from player
@export_range(-5.0,5.0) var speed_modifier: float = 1.0

@onready var nave: NavigationAgent2D = $NavigationAgent2D
var target: Node2D
var roam_target: Vector2

#knockback handling
var is_knockback_active: bool = false
var knockback_timer: Timer
var knockback_velocity: Vector2

#for fear
var fear_active: bool = false
var fixed_pos: Vector2

#for blind
var blind_active: bool = false
var blind_timer: Timer
var circle_center: Vector2
var circle_radius: float = 100.0
var circle_speed: float = 2.0
var circle_angle: float = 0.0

func _ready() -> void:
	area_radius.shape.radius = radius_detector
	nave.path_desired_distance = 10.0
	nave.target_desired_distance = stopping_distance
	
	#knockback timer
	knockback_timer = Timer.new()
	knockback_timer.one_shot = true
	add_child(knockback_timer)
	
	#blind timer
	blind_timer = Timer.new()
	blind_timer.one_shot = true
	add_child(blind_timer)

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
	
	if fear_active:
		var pos: Vector2 = fixed_pos * -1
		nave.set_target_position(pos)
		return
	
	if blind_active:
		circle_center = get_parent().global_position
		nave.set_target_position(circle_center)
		return
	
	if target != null and is_instance_valid(target):
		nave.set_target_position(target.global_position)
		fixed_pos = target.global_position
	elif roam_target != Vector2.ZERO:
		nave.set_target_position(roam_target)
		fixed_pos = roam_target
	else:
		nave.set_target_position(get_parent().global_position)
	

func _physics_process(delta: float) -> void:
	#handle knockback
	if is_knockback_active:
		get_parent().velocity = knockback_velocity
		get_parent().move_and_slide()
		return
	
	#handle blind
	if blind_active:
		circle_angle += circle_speed * delta
		var offset: Vector2 = Vector2(cos(circle_angle), sin(circle_angle)) * circle_radius
		get_parent().velocity = offset.normalized() * get_parent().stats.speed * 0.5 #move at half speed
		get_parent().move_and_slide()
		return
	
	if nave.is_navigation_finished() or get_parent().stats.isDead:
		get_parent().velocity = Vector2.ZERO
		get_parent().move_and_slide()
		if target == null and roam_target != Vector2.ZERO:
			set_new_roam_target()
		return
	
	#get distance to target
	var distance_to_target: float = INF if target == null else get_parent().global_position.distance_to(target.global_position)
	var distance_to_roam: float = INF if roam_target == Vector2.ZERO else get_parent().global_position.distance_to(roam_target)
	
	
	#if too close look for another point
	if target == null and distance_to_roam <= stopping_distance:
		set_new_roam_target()
	
	#if too close stop
	if target != null and distance_to_target <= stopping_distance:
		get_parent().velocity = Vector2.ZERO
		get_parent().move_and_slide()
		return
	
	#get position to next node
	var next_pos: Vector2 = nave.get_next_path_position()
	var direction: Vector2 = (next_pos - get_parent().global_position).normalized()
	
	# Adjust speed based on distance to target
	var speed: float = get_parent().stats.speed * speed_modifier
	if target != null and distance_to_target < stopping_distance * 1.5:
		speed *= (distance_to_target - stopping_distance) / (stopping_distance * 0.5)
	elif roam_target != Vector2.ZERO and distance_to_roam < stopping_distance * 1.5:
		speed *= (distance_to_roam - stopping_distance) / (stopping_distance * 0.5)
	
	#set move
	if target != null:
		get_parent().velocity = get_parent().velocity.lerp((direction).normalized() * (get_parent().stats.speed), get_parent().stats.acceleration * delta)
	elif roam_target != Vector2.ZERO:
		get_parent().velocity = get_parent().velocity.lerp((direction).normalized() * (get_parent().stats.speed / 2), get_parent().stats.acceleration * delta)
	get_parent().move_and_slide()

func set_new_roam_target() -> void:
	var angle: float = randf_range(0, TAU)
	var distan: float = randf_range(stopping_distance * 1.5, radius_detector/2)
	roam_target = get_parent().global_position + Vector2(distan * cos(angle), distan * sin(angle))
	nave.set_target_position(roam_target)

func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		roam_target = Vector2.ZERO
		nave.set_target_position(target.global_position)

func _on_target_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		nave.set_target_position(get_parent().global_position)
