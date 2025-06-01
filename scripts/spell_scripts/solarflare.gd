extends base_script
class_name Solarflare

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void: 
	super._ready()
	ray_cast_2d.target_position = ray_cast_2d.to_local(get_global_mouse_position())
	
	line_2d.clear_points()
	
	var start: Vector2 = ray_cast_2d.target_position
	line_2d.add_point(start)
	
	var numOfBeams: int = 5
	var line_length: float = 250.0
	
	for i in range(numOfBeams):
		var angle: float = randf() * ray_cast_2d.target_position.angle() * PI #random angle from 0 to 2pi
		var dir: Vector2 = Vector2(cos(angle),sin(angle))
		var end: Vector2 = start + dir * line_length
		
		line_2d.add_point(end)
		
		if i < numOfBeams - 1: 
			line_2d.add_point(start)
	
	#TODO add collisions to easy beam
	#FIXME when on the left side, it creates a circle instead. 
	#FIXME doesn't always instantiate??
