extends Area2D
class_name Hurtbox

@onready var obj_data: Resource = self.get_parent().stats

func _ready() -> void:
	SignalBus.connect("apply_dmg_debuff", apply_dmg_debuff)


func apply_dmg_debuff(dmg: int, debuff: int, dmgDealer: StringName, dmgReceiver: StringName) -> void:
	if !(get_parent().name == dmgDealer) and get_parent().name == dmgReceiver:
		obj_data.current_health -= dmg
		SignalBus.emit_signal("updateUi")
		#print(get_parent().name ," has taken " , dmg , " dmg")
	
		#TODO code to apply debuffs
		#print("applied debuff: ", debuff, " to ", dmgReceiver) #1-burn,2-freeze,3-blindness,4-slowness,5-fear,6-stun
		SignalBus.emit_signal("dmg_debuff_applied", debuff, dmgReceiver)
	
		if obj_data.current_health <= 0:
			obj_data.current_health = 0
			SignalBus.emit_signal("dead", get_parent().name)
