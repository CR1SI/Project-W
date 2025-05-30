extends Control
class_name debugHP_MANA

@onready var player: Player = $".."

@onready var hp: Label = %hp
@onready var mana: Label = %mana

func _ready() -> void:
	hp.text = "HP: " + str(player.stats.current_health)
	mana.text = "MANA: " + str(player.stats.mana)
	
	SignalBus.connect("apply_dmg_debuff", Callable(self, "update"))
	SignalBus.connect("spell_casted", Callable(self, "updateMANA"))
	


func update() -> void:
	hp.text = "HP: " + str(player.stats.current_health)

func updateMANA(_mana_cost : int) -> void:
	player.stats.mana -= _mana_cost
	mana.text = "MANA: " + str(player.stats.mana)
