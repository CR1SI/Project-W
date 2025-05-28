class_name Stats
extends Resource

#TODO make setter functions for health and mana, use signals, and ensure buffs and debuffs can work
@export var max_health : int 
var current_health : int = max_health
@export var defense : int
@export var strength : int
@export var max_mana : int
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
