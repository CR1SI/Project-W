extends Resource
class_name Spell

enum Elements { 
	WATER, 
	WIND,
	FIRE,
	EARTH,
	LIGHT,
	DARKNESS
}


@export var spell_cost: int
@export var cooldown: float
@export var spell_duration: float

@export var spell_type: Elements
@export var dmg: int
@export var spell_speed: int

@export var can_combine: bool

@export var requires_targeting: bool = false

var is_on_cooldown: bool = false
