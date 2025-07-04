# res://scripts/spell_scripts/solarflare.gd
extends base_script
class_name Solarflare

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

func _ready() -> void: 
	super._ready()
	ray_cast_2d.target_position = ray_cast_2d.to_local(get_global_mouse_position())
	
	line_2d.clear_points()
	
	var start: Vector2 = ray_cast_2d.target_position
	line_2d.add_point(start)
	
	var numOfBeams: int = 5
	var line_length: float = 250.0
	
	for i in range(numOfBeams):
		var angle: float = randf() * TAU # Random angle from 0 to 2pi (fixed from previous PI)
		var dir: Vector2 = Vector2(cos(angle), sin(angle))
		var end: Vector2 = start + dir * line_length
		
		line_2d.add_point(end)
		
		if i < numOfBeams - 1: 
			line_2d.add_point(start)
	
	# Update hitbox size based on line points
	update_hitbox()

func update_hitbox() -> void:
	var points: PackedVector2Array = line_2d.points
	if points.size() < 2:
		return
	
	# Calculate bounds of all points
	var min_point: Vector2 = points[0]
	var max_point: Vector2 = points[0]
	
	for point: Vector2 in points:
		min_point = min_point.min(point)
		max_point = max_point.max(point)
	
	# Calculate center and size of the hitbox
	var size: Vector2 = max_point - min_point
	var center: Vector2 = (min_point + max_point) * 0.5
	
	# Update hitbox position and collision shape
	hitbox.position = center
	hitbox_collision.shape.radius = max(size.x, size.y) * 0.5
