extends Area2D
class_name Hurtbox

@onready var obj_data: Resource = self.get_parent().stats

func _ready() -> void:
	SignalBus.connect("apply_dmg_debuff", Callable(self, "apply_dmg_debuff"))


func apply_dmg_debuff(dmg: int, _debuff, dmgDealer: StringName) -> void:
	
	if !(get_parent().name == dmgDealer):
		obj_data.current_health -= dmg
		SignalBus.emit_signal("updateUi")
		print(get_parent().name ," has taken " , dmg , " dmg")
	
		#TODO code to apply debuffs
		#SignalBus.emit_signal("dmg_debuff_applied")
	
		if obj_data.current_health <= 0:
			obj_data.current_health = 0
			SignalBus.emit_signal("dead", get_parent().name)
