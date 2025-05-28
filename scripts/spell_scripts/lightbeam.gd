extends base_script
class_name Lightbeam

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void: 
	super._ready()
	ray_cast_2d.target_position = ray_cast_2d.to_local(get_global_mouse_position())
	
	line_2d.points[1].x = ray_cast_2d.target_position.x
	line_2d.points[1].y = ray_cast_2d.target_position.y
	
	collision.shape.b = ray_cast_2d.target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
