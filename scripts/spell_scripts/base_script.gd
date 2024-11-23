class_name base_script
extends Area2D

@export var resource: Spell
@export var id: String = ""
@export var icon: Texture2D

var direction: Vector2 = Vector2.ZERO
var spell_fired: bool = false

func _ready():
	add_to_group("spells")
	connect("area_entered", Callable(self, "_on_area_entered"))
	fire_spell()
	pass

func _process(delta: float) -> void:
	if spell_fired:
		position += direction * resource.spell_speed * delta
		await get_tree().create_timer(resource.spell_duration).timeout
		queue_free()

func fire_spell():
	
	if resource.requires_targeting:
		direction = Vector2.ZERO
	else: 
		direction = (get_global_mouse_position() - position).normalized()
	
	spell_fired = true

func deal_damage(_dmg: int): 	#deal dmg stuff here
	pass

func _on_area_entered(area: Area2D):
	if area is base_script and resource.can_combine: 
		SignalBus.emit_signal("spell_collided", self, area)
