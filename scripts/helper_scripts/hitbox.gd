extends Area2D
class_name Hitbox

var obj_data: Resource

func _ready() -> void:
	if self.get_parent().is_in_group("player") or self.get_parent().is_in_group("enemy") or self.get_parent().is_in_group("companion"):
		obj_data = self.get_parent().stats
	else:
		obj_data = self.get_parent().data

func dmg_info() -> int:
	return obj_data.dmg

func debuff_info() -> Spell.Debuffs:
	if self.get_parent().is_in_group("player") or self.get_parent().is_in_group("enemy") or self.get_parent().is_in_group("companion"):
		return Spell.Debuffs.NONE
	else: #right now only coming from spells
		return obj_data.debuff


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox") and !(area.get_parent() == self.get_parent()) and !(area.get_parent().get_groups() == self.get_parent().get_groups()):
		if self.get_parent().is_in_group("spells") and area.get_parent().is_in_group("player"):
			pass
		else:
			var dmg: int = dmg_info()
			SignalBus.emit_signal("apply_dmg_and_debuff", dmg, debuff_info(), get_parent().name, area.get_parent().name)
			SignalBus.emit_signal("do_hitstop", 0.1)
			
			#knockback
			if obj_data.deal_knockback:
				SignalBus.emit_signal("knockback", area.get_parent(), obj_data.knockback_amount * 5, self.global_position)
			
			#destroy spell
			if self.get_parent().is_in_group("spells") and obj_data.destroy_on_impact:
				self.get_parent().queue_free()
			
			#pull towards center
			if self.get_parent().is_in_group("spells") and obj_data.pull_inside:
				SignalBus.emit_signal("pull_inside", self.get_parent(), area.get_parent())
