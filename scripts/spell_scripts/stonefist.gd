extends base_script
class_name Stonefist
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	
	animation_player.play("stonefist")

func deal_damage(_dmg: int):  #overrides the dmg func in the base script
	pass
