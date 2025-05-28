extends base_script
class_name Shadowbolt
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	var angle: float = get_angle_to(get_global_mouse_position())
	set_global_rotation(angle)
	animation_player.play("shadowbolt")
	
