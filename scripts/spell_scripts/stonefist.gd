class_name Stonefist
extends base_script

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	
	animation_player.play("stonefist")
