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

enum Debuffs{ #once enemy enters spell, it checks for debuff, while enemy inside spell debuff is applied. it last 1-2 seconds after spell leaves
	NONE,
	BURN,
	FREEZE,
	BLINDNESS,
	SLOWNESS,
	FEAR,
	STUN
}


@export var spell_cost: int
@export var cooldown: float
@export var spell_duration: float
@export var debuff: Debuffs

@export var spell_type: Elements
@export var dmg: int
@export var spell_speed: int

@export var can_combine: bool
@export var is_combination: bool

@export var requires_targeting: bool = false
@export var on_player: bool = false

var is_on_cooldown: bool = false

@export var deal_knockback: bool
@export_range(0.0, 100.0, 15.0) var knockback_amount: float

@export var icon: Texture2D
