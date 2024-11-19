class_name SpellManager
extends Node

@onready var player: Player = $".."

var target = preload("res://textures/spell_textures/target.png") #100x100
var default_aim = preload("res://textures/spell_textures/aim.png") #16x16

var is_targeting: bool = false

enum SpellType { 
	FIREBALL,
	WATERFALL
}

var spell_scenes = { 
	SpellType.FIREBALL : preload("res://scenes/spells/fireball.tscn"),
	SpellType.WATERFALL : preload("res://scenes/spells/water_fall.tscn")
}

var selected_spell: SpellType = -1
var spell_fired: bool = false

var cooldowns = {} #to track cooldowns!

func _ready(): 
	for spell in spell_scenes.keys(): 
		cooldowns[spell] = false

func cast_spell(spell: SpellType, position: Vector2): 
	if spell in spell_scenes: 
		#check if on cooldown!
		if cooldowns[spell]: 
			print("spell on cooldown")
			return
		
		var spell_scene = spell_scenes[spell]
		var spell_instance = spell_scene.instantiate()
		
		
		spell_instance.position = position
		add_child(spell_instance)
		
		start_cooldown(spell)

func start_cooldown(spell: SpellType): 
	cooldowns[spell] = true
	var spell_resource = spell_scenes[spell].instantiate().resource
	var cool_timer = get_tree().create_timer(spell_resource.cooldown)
	await cool_timer.timeout
	cooldowns[spell] = false
	print("cooldown over")

func select_spell(spell_index: int): 
	match spell_index: 
		0: 
			selected_spell = SpellType.FIREBALL
		1:
			selected_spell = SpellType.WATERFALL
	
	if selected_spell > -1 and spell_scenes[selected_spell].instantiate().resource.requires_targeting:
		start_targeting(spell_scenes[selected_spell].instantiate())

#spell targeting logic
func start_targeting(_spell_instance): 
	is_targeting = true
	Input.set_custom_mouse_cursor(target, Input.CURSOR_ARROW, Vector2(50,50))
	#(resource, shape, offset)

func stop_targeting(): 
	is_targeting = false
	Input.set_custom_mouse_cursor(default_aim)
	cast_spell(selected_spell, player.mouse_position)
