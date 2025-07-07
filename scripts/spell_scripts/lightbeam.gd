extends base_script
class_name Lightbeam

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

const MAX_DISTANCE_FROM_PLAYER: float = 800.0
const HITBOX_SPACING: float = 50.0

func _ready() -> void: 
	super._ready()
	var mp: Vector2 = get_global_mouse_position()
	direction = (mp - global_position).normalized()
	
	var target_pos: Vector2 = global_position + direction * MAX_DISTANCE_FROM_PLAYER
	ray_cast_2d.target_position = ray_cast_2d.to_local(target_pos)
	
	line_2d.points[1] = ray_cast_2d.target_position
	
	collision.shape.a = Vector2.ZERO
	collision.shape.b = ray_cast_2d.target_position
	
	update_hitbox()

func update_hitbox() -> void:
	var beam_length: float = ray_cast_2d.target_position.length()
	direction = ray_cast_2d.target_position.normalized()
	
	# Calculate number of hitboxes needed
	var hitbox_count: Variant = ceil(beam_length / HITBOX_SPACING)
	
	# Clear existing hitboxes (except the first one)
	for child: CollisionShape2D in hitbox.get_children():
		if child != hitbox_collision:
			child.queue_free()
	
	# Create additional hitboxes along the beam #FIXME only first collision detecting!
	for i: int  in range(1, hitbox_count):
		var offset: Vector2 = direction * (i * HITBOX_SPACING)
		var new_collision: CollisionShape2D = hitbox_collision.duplicate()
		new_collision.position = offset
		hitbox_collision.shape.radius = 50
		hitbox.add_child(new_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	update_hitbox()
