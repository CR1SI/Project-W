class_name Stats
extends Resource

#TODO make setter functions for health and mana, use signals, and ensure buffs and debuffs can work
@export var max_health : int:
	set(value):
		max_health = value
		current_health = max_health
var current_health : int = max_health:
	set(value):
		current_health = value
@export var defense : int
@export var strength : int
@export var max_mana : int:
	set(value):
		max_mana = value
		mana = max_mana
@export var dmg : int :
	set(value):
		dmg = value
	get():
		return dmg * strength
var mana : int = max_mana :
	set(value):
		mana = value

#BUFFS
var healthBUFF : int
var strengthBUFF : int
var defenseBUFF : int
var speedBUFF : float

@export var speed : float :
	set(value):
		speed = value

@export var acceleration : int :
	set(value):
		acceleration = value

#companion variables
@export var is_companion: bool = false
@export_enum("comp1", "comp2", "comp3", "comp4","comp5","player") var companion: int = 0
@export var attackingCompanion: bool = false
@export var on_head: bool
