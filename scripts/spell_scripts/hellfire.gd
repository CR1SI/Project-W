extends base_script
class_name Hellfire

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	
	var angle = get_angle_to(get_global_mouse_position())
	set_global_rotation(angle)
	animation_player.play("hellfire")
	
