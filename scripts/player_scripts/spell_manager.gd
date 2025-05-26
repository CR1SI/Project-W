class_name SpellManager
extends Node

@onready var player: Player = $".."



var target = preload("res://textures/spell_textures_placeholders/target.png") #100x100
var default_aim = preload("res://textures/spell_textures_placeholders/aim.png") #16x16

var is_targeting: bool = false

enum SpellType {
	FIREBALL,
	WATERFALL,
	CYCLONE, 
	STONEFIST, 
	LIGHTBEAM,
	SHADOWBOLT
}

enum SpellCombo { 
	SMOKESCREEN,
	FIRECYCLONE
}

var combo_scenes = { 
	SpellCombo.SMOKESCREEN : preload("res://scenes/spells/smokescreen.tscn"),
	SpellCombo.FIRECYCLONE : preload("res://scenes/spells/firecyclone.tscn")
}

var spell_scenes = { 
	SpellType.FIREBALL : preload("res://scenes/spells/fireball.tscn"),
	SpellType.WATERFALL : preload("res://scenes/spells/water_fall.tscn"),
	SpellType.CYCLONE : preload("res://scenes/spells/cyclone.tscn"),
	SpellType.STONEFIST : preload("res://scenes/spells/stonefist.tscn"),
	SpellType.LIGHTBEAM : preload("res://scenes/spells/lightbeam.tscn"),
	SpellType.SHADOWBOLT : preload("res://scenes/spells/shadowbolt.tscn")
}

var spell_combinations = { 
	"Fireball_WaterFall" : SpellCombo.SMOKESCREEN,
	"Fireball_Cyclone" : SpellCombo.FIRECYCLONE,
}


var active_bar = {
	0 : spell_scenes[SpellType.WATERFALL],
	1 : spell_scenes[SpellType.FIREBALL],
	2 : spell_scenes[SpellType.CYCLONE],
	3 : spell_scenes[SpellType.SHADOWBOLT]
}

var selected_spell: SpellType = -1
var spell_fired: bool = false

var cooldowns = {} #to track cooldowns!

func _ready():
	SignalBus.connect("spell_collided", Callable(self, "_on_collided"))
	SignalBus.connect("spell_selected", Callable(self, "select_spell"))
	for spell in spell_scenes.keys(): 
		cooldowns[spell] = false
	

func cast_spell(spell: SpellType, position: Vector2): 
	if spell in active_bar: 
		#check if on cooldown!
		if cooldowns[spell]: 
			print("spell on cooldown")
			return
		
		var spell_scene = active_bar[spell]
		var spell_instance = spell_scene.instantiate()
		
		spell_instance.position = position
		add_child(spell_instance)
		
		start_cooldown(spell)

func cast_combo(combo: SpellCombo, position: Vector2): 
	if combo in combo_scenes: 
		
		var combo_scene = combo_scenes[combo]
		var spell_instance = combo_scene.instantiate()
		
		spell_instance.position = position
		call_deferred("add_child",spell_instance)
		


func start_cooldown(spell: SpellType): 
	cooldowns[spell] = true
	var spell_resource = active_bar[spell].instantiate().resource
	SignalBus.emit_signal("spell_fired", spell_resource.cooldown, active_bar.find_key(active_bar[spell]))
	var cool_timer = get_tree().create_timer(spell_resource.cooldown)
	await cool_timer.timeout
	cooldowns[spell] = false
	print("cooldown over")

func select_spell(spell_index: int): 
	match spell_index: 
		1: 
			selected_spell = active_bar.find_key(active_bar[0])
		2:
			selected_spell = active_bar.find_key(active_bar[1])
		3:
			selected_spell = active_bar.find_key(active_bar[2])
		4: 
			selected_spell = active_bar.find_key(active_bar[3])
	
	if selected_spell > -1 and active_bar[selected_spell].instantiate().resource.requires_targeting:
		start_targeting(active_bar[selected_spell].instantiate())
	elif selected_spell > -1 and not active_bar[selected_spell].instantiate().resource.requires_targeting:
		stop_targeting()

#spell targeting logic
func start_targeting(_spell_instance): 
	is_targeting = true
	Input.set_custom_mouse_cursor(target, Input.CURSOR_ARROW, Vector2(50,50))
	#(resource, shape, offset)

func stop_targeting(): 
	is_targeting = false
	Input.set_custom_mouse_cursor(default_aim, Input.CURSOR_ARROW, Vector2(8,8))
	if active_bar[selected_spell].instantiate().resource.requires_targeting:
		cast_spell(selected_spell, player.mouse_position)
	else: 
		return


var processed_combinations: Dictionary = {}
var current_frame = 0
func _on_collided(spell1, spell2): 
	current_frame = Engine.get_physics_frames() #get frame on collision
	
	print("collided spell1:",spell1, "with: ," , spell2)
	
	#create key for combination
	var combination = [spell1.get_name(), spell2.get_name()]
	combination.sort()
	var key = String(combination[0]) + "_" + String(combination[1])
	
	if key in processed_combinations: 
		return
	
	processed_combinations[key] = current_frame
	if key in spell_combinations:
		combine_spells(spell1,spell2,spell_combinations[key])
		reset_combinations(key)

func combine_spells(spell1,spell2, combo: SpellCombo):
	#TODO await to play combining animation!
	var position = (spell1.global_position + spell2.global_position) / 2
	spell1.call_deferred("queue_free")
	spell2.call_deferred("queue_free")
	
	cast_combo(combo,position)

func reset_combinations(key: String): #if needed
	if key in processed_combinations:
		processed_combinations.erase(key)
