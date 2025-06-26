class_name base_script
extends Area2D

@export var data: Spell

var direction: Vector2 = Vector2.ZERO
var spell_fired: bool = false
var player: Player = Nodes.player

func _ready() -> void:
	add_to_group("spells")
	connect("area_entered", Callable(self, "_on_area_entered"))
	fire_spell()

func _process(delta: float) -> void:
	if spell_fired:
		position += direction * data.spell_speed * delta
		await get_tree().create_timer(data.spell_duration).timeout
		queue_free()

func fire_spell() -> void:
	if data.requires_targeting or data.on_player:
		direction = Vector2.ZERO
	else: 
		direction = player.last_direction #(get_global_mouse_position() - position).normalized()
	
	spell_fired = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("spells") and data.can_combine:
		SignalBus.emit_signal("spell_collided", self, area)
