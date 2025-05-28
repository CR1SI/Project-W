class_name SpellManager
extends Node

@onready var player: Player = $".."

var target: Texture2D = preload("res://textures/spell_textures_placeholders/target.png") #100x100
var default_aim: Texture2D = preload("res://textures/spell_textures_placeholders/aim.png") #16x16

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
	FIRECYCLONE,
	MAGMAFIST,
	HELLFIRE
}

var combo_scenes: Dictionary = { 
	SpellCombo.SMOKESCREEN : preload("res://scenes/spells/smokescreen.tscn"),
	SpellCombo.FIRECYCLONE : preload("res://scenes/spells/firecyclone.tscn"),
	SpellCombo.MAGMAFIST : preload("res://scenes/spells/magmafist.tscn"),
	SpellCombo.HELLFIRE : preload("res://scenes/spells/hellfire.tscn")
}

var spell_scenes: Dictionary = { 
	SpellType.FIREBALL : preload("res://scenes/spells/fireball.tscn"),
	SpellType.WATERFALL : preload("res://scenes/spells/water_fall.tscn"),
	SpellType.CYCLONE : preload("res://scenes/spells/cyclone.tscn"),
	SpellType.STONEFIST : preload("res://scenes/spells/stonefist.tscn"),
	SpellType.LIGHTBEAM : preload("res://scenes/spells/lightbeam.tscn"),
	SpellType.SHADOWBOLT : preload("res://scenes/spells/shadowbolt.tscn"),
}

var spell_combinations: Dictionary = { 
	"Fireball_WaterFall" : SpellCombo.SMOKESCREEN,
	"Fireball_Cyclone" : SpellCombo.FIRECYCLONE,
	"Fireball_Stonefist" : SpellCombo.MAGMAFIST,
	"Fireball_Shadowbolt" : SpellCombo.HELLFIRE,
}


var active_bar: Dictionary = {
	0 : spell_scenes[SpellType.STONEFIST],
	1 : spell_scenes[SpellType.FIREBALL],
	2 : spell_scenes[SpellType.CYCLONE],
	3 : spell_scenes[SpellType.SHADOWBOLT],
	4 : spell_scenes[SpellType.WATERFALL],
	5 : spell_scenes[SpellType.LIGHTBEAM]
}

var selected_spell: SpellType
var spell_fired: bool = false

var cooldowns: Dictionary = {} #to track cooldowns!

func _ready()  -> void:
	SignalBus.connect("spell_collided", Callable(self, "_on_collided"))
	SignalBus.connect("spell_selected", Callable(self, "select_spell"))
	for spell: SpellType in spell_scenes.keys():
		cooldowns[spell] = false
	

func cast_spell(spell: SpellType, position: Vector2) -> void: 
	if spell in active_bar: 
		#check if on cooldown!
		if cooldowns[spell]: 
			print("spell on cooldown")
			return
		
		var spell_scene: PackedScene = active_bar[spell]
		var spell_instance: Node  = spell_scene.instantiate()
		
		spell_instance.position = position
		add_child(spell_instance)
		
		start_cooldown(spell)

func cast_combo(combo: SpellCombo, position: Vector2) -> void: 
	if combo in combo_scenes: 
		
		var combo_scene: PackedScene = combo_scenes[combo]
		var spell_instance: Node = combo_scene.instantiate()
		
		spell_instance.position = position
		call_deferred("add_child",spell_instance)
		


func start_cooldown(spell: SpellType) -> void: 
	cooldowns[spell] = true
	var spell_resource: Spell = active_bar[spell].instantiate().data
	SignalBus.emit_signal("spell_fired", spell_resource.cooldown, active_bar.find_key(active_bar[spell]))
	var cool_timer: SceneTreeTimer = get_tree().create_timer(spell_resource.cooldown)
	await cool_timer.timeout
	cooldowns[spell] = false
	print("cooldown over")

func select_spell(spell_index: int) -> void: 
	match spell_index: 
		1: 
			selected_spell = active_bar.find_key(active_bar[0])
		2:
			selected_spell = active_bar.find_key(active_bar[1])
		3:
			selected_spell = active_bar.find_key(active_bar[2])
		4: 
			selected_spell = active_bar.find_key(active_bar[3])
	
	if selected_spell > -1 and active_bar[selected_spell].instantiate().data.requires_targeting:
		start_targeting(active_bar[selected_spell].instantiate())
	elif selected_spell > -1 and not active_bar[selected_spell].instantiate().data.requires_targeting:
		stop_targeting()

#spell targeting logic
func start_targeting(_spell_instance: Node) -> void: 
	is_targeting = true
	Input.set_custom_mouse_cursor(target, Input.CURSOR_ARROW, Vector2(50,50))
	#(resource, shape, offset)

func stop_targeting() -> void: 
	is_targeting = false
	Input.set_custom_mouse_cursor(default_aim, Input.CURSOR_ARROW, Vector2(8,8))
	if active_bar[selected_spell].instantiate().data.requires_targeting:
		cast_spell(selected_spell, player.mouse_position)
	else: 
		return


var processed_combinations: Dictionary = {}
var current_frame: int = 0
func _on_collided(spell1: Area2D, spell2: Area2D) -> void:
	current_frame = Engine.get_physics_frames() #get frame on collision
	
	print("collided spell1:",spell1, "with: ," , spell2)
	
	#create key for combination
	var combination: Array = [spell1.get_name(), spell2.get_name()]
	combination.sort()
	var key: String = String(combination[0]) + "_" + String(combination[1])
	
	if key in processed_combinations: 
		return
	
	processed_combinations[key] = current_frame
	if key in spell_combinations:
		combine_spells(spell1,spell2,spell_combinations[key])
		reset_combinations(key)

func combine_spells(spell1: Area2D,spell2: Area2D, combo: SpellCombo) -> void:
	#TODO await to play combining animation!
	var position: Vector2 = (spell1.global_position + spell2.global_position) / 2
	#spell1.call_deferred("queue_free") in case queue_free doesn't work
	#spell2.call_deferred("queue_free") in case queue_free doesn't work
	spell1.queue_free()
	spell2.queue_free()
	
	cast_combo(combo,position)

func reset_combinations(key: String) -> void: #if needed
	if key in processed_combinations:
		processed_combinations.erase(key)
