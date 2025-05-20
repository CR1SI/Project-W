@tool #code runs in the editor as well
extends Button

@onready var spell_manager: SpellManager = $/root/test_scene/Player/SpellManager
@export var spell: Spell

func _ready() -> void:
	SignalBus.connect("spell_fired", Callable(self,"_on_spell_fired"))
	
	var name: String = self.name
	var num: int = int(name[5])
	spell = spell_manager.active_bar[(num-1)].instantiate().resource
	
	icon = spell.icon
	text = name[5]

func _on_spell_fired(time: float, num: int):
	
	match num:
		0:
			if self.name == "Spell1":
				self_modulate = Color(0,0,0)
				var cool_timer = get_tree().create_timer(time)
				await cool_timer.timeout
				self_modulate = Color(1,1,1)
		1:
			if self.name == "Spell2":
				self_modulate = Color(0,0,0)
				var cool_timer = get_tree().create_timer(time)
				await cool_timer.timeout
				self_modulate = Color(1,1,1)
		2:
			if self.name == "Spell3":
				self_modulate = Color(0,0,0)
				var cool_timer = get_tree().create_timer(time)
				await cool_timer.timeout
				self_modulate = Color(1,1,1)
		3:
			if self.name == "Spell4":
				self_modulate = Color(0,0,0)
				var cool_timer = get_tree().create_timer(time)
				await cool_timer.timeout
				self_modulate = Color(1,1,1)
		
