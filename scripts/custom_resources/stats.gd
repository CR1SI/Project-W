class_name Stats
extends Resource

@export var max_health : int 
@export var defense : int
@export var strength : int
@export var max_mana : int
var mana : int = max_mana

@export var speed : float
@export var acceleration : int

@export var is_companion: bool = false
@export_enum("slime", "comp2", "comp3", "comp4","comp5","player") var companion = 0
@export var attackingCompanion: bool = false
