class_name Magma_Fist
extends base_script

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	super._ready()
	
	animation_player.play("magmafist")
	particles.lifetime = data.spell_duration
