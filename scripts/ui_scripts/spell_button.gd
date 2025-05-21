@tool #code runs in the editor as well
extends Button

@onready var spell_manager: SpellManager = $/root/test_scene/Player/SpellManager
@export var spell: Spell

func _ready() -> void:
	SignalBus.connect("spell_fired", Callable(self,"_on_spell_fired"))
	
	@warning_ignore("shadowed_variable_base_class")
	var name: String = self.name
	var num: int = int(name[5])
	spell = spell_manager.active_bar[(num-1)].instantiate().resource
	
	icon = spell.icon
	text = name[5]

func _on_spell_fired(time: float, num: int): #this will be used for nicer cooldown visualization later
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
		

func _on_pressed() -> void: #sends signal to spell manager to select spell function
	var spellNum: int
	
	if self.name == "Spell1":
		spellNum = 1
	elif self.name == "Spell2":
		spellNum = 2
	elif self.name == "Spell3":
		spellNum = 3
	elif self.name == "Spell4":
		spellNum = 4
	else:
		pass
	print("spell selected: ", spellNum)
	SignalBus.emit_signal("spell_selected", spellNum)
