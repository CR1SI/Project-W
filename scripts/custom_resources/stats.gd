class_name Stats
extends Resource

#IMPORTANT look over buffs and debuffs
@export var max_health : float:
	set(value):
		max_health = value
		current_health = max_health
	get():
		return max_health * healthBUFF

var current_health : float = max_health:
	set(value):
		current_health = clamp(value, 0, max_health)

@export var defense : float:
	set(value):
		defense = value
	get():
		return defense * defenseBUFF

@export var strength : float:
	set(value):
		strength = value
	get():
		return strength * strengthBUFF

@export var max_mana : int:
	set(value):
		max_mana = value
		mana = max_mana

@export var dmg : float :
	set(value):
		dmg = value
	get():
		var calculated_dmg: float = (dmg * strength)
		calculated_dmg = clamp(calculated_dmg, 0, max_health)
		return calculated_dmg

var mana : int = max_mana :
	set(value):
		mana = clamp(value, 0, max_mana)

#BUFFS give buffs values greater than 1 and debuffs values less than 1
var healthBUFF : float = 1.0:
	set(value):
		healthBUFF = value
var strengthBUFF : float = 1.0:
	set(value):
		strengthBUFF = value
var defenseBUFF : float = 1.0:
	set(value):
		defenseBUFF = value
var speedBUFF : float = 1.0:
	set(value):
		speedBUFF = value

@export var speed : float :
	set(value):
		speed = value
	get():
		return speed * speedBUFF

@export var acceleration : int :
	set(value):
		acceleration = value

@export var deal_knockback: bool
@export_range(0.0, 100.0, 15.0) var knockback_amount: float

#can follow footsteps
@export var canFollowSteps: bool = false

#dead variable
var isDead : bool = false

#companion variables
@export var is_companion: bool = false
@export_enum("comp1", "comp2", "comp3", "comp4","comp5","player") var companion: int = 0
@export var attackingCompanion: bool = false
@export var on_head: bool
