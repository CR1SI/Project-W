extends Area2D
class_name Hurtbox

@onready var obj_data: Resource = self.get_parent().stats

func _ready() -> void:
	SignalBus.connect("apply_dmg_and_debuff", apply_dmg_debuff)

func apply_dmg_debuff(dmg: int, debuff: int, dmgDealer: StringName, dmgReceiver: StringName) -> void:
	if !(get_parent().name == dmgDealer) and get_parent().name == dmgReceiver:
		var initial_health: int = obj_data.current_health
		# Calculate effective defense using defense * defenseBUFF
		var effective_defense: int = obj_data.defense
		var defense_reduction_factor: float = clamp(1.0 - (float(effective_defense) / 100.0), 0.0, 1.0)
		var effective_dmg: int = int(dmg * defense_reduction_factor)
		obj_data.current_health = initial_health - effective_dmg
		SignalBus.emit_signal("updateUi")
		print("%s has taken %d dmg (raw: %d, defense: %d, defenseBUFF: %.2f, reduction_factor: %.2f, new health: %d)" % [
			get_parent().name, effective_dmg, dmg, obj_data.defense, obj_data.defenseBUFF, defense_reduction_factor, obj_data.current_health
		])
		#print("applied debuff: ", debuff, " to ", dmgReceiver) #1-burn,2-freeze,3-blindness,4-slowness,5-fear,6-stun
		SignalBus.emit_signal("dmg_debuff_applied", debuff, dmgReceiver)
		
		if obj_data.current_health <= 0:
			obj_data.current_health = 0
			SignalBus.emit_signal("dead", get_parent().name)
