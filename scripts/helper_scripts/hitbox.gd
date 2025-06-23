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
		return 0
	else: #right now only coming from spells
		return obj_data.debuff


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox") and !(area.get_parent() == self.get_parent()):
		if self.get_parent().is_in_group("spells") and area.get_parent().is_in_group("player"):
			pass
		else:
			var dmg: int = dmg_info()
			print("%s entered hurtbox of %s and dealt %d dmg (is_spell: %s)" % [
				self.get_parent().name, area.get_parent().name, dmg, self.get_parent().is_in_group("spells")
			])
			SignalBus.emit_signal("apply_dmg_debuff", dmg, debuff_info(), get_parent().name, area.get_parent().name)
