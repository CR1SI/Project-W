extends Node2D
class_name debuff_manager

@export var being: CharacterBody2D

var current_debuffs: Array = []
#1-burn,2-freeze,3-blindness,4-slowness,5-fear,6-stun
var remove_queue: Array = []
#remove queue
var tick_timers: Dictionary = {}
#keeps track of ticks for each spell

const DOT = {
	1: {"tick_interval": 0.5, "dmg_per_tick": 5.0}, #burn
	2: {"tick_interval": 0.5, "dmg_per_tick": 10.0}, #freeze
	3: {"tick_interval": 1, "dmg_per_tick": 0}, #blindness
	4: {"tick_interval": 1, "dmg_per_tick": 0}, #slowness
	5: {"tick_interval": 1, "dmg_per_tick": 0}, #fear
	6: {"tick_interval": 1, "dmg_per_tick": 0} #stun
}

func _ready() -> void:
	SignalBus.connect("dmg_debuff_applied", apply)

func _process(_delta: float) -> void:
	if remove_queue.size() > 0:
		for i: int in remove_queue:
			current_debuffs.erase(i)
			if tick_timers.has(i):
				if is_instance_valid(tick_timers[i]):
					tick_timers[i].queue_free()
				tick_timers.erase(i)
		remove_queue.clear()

func apply(incoming: int, dmgReceiver: StringName) -> void:
	if dmgReceiver == being.name:
		if incoming < 1 or incoming > 6:
			return
		current_debuffs.append(incoming)
		#create tick timers
		if DOT[incoming]["dmg_per_tick"] > 0:
			var tick_timer: Timer = Timer.new()
			tick_timer.wait_time = DOT[incoming]["tick_interval"]
			tick_timer.connect("timeout", apply_tick.bind(incoming))
			add_child(tick_timer)
			tick_timers[incoming] = tick_timer
			tick_timer.start()
		call_debuff(incoming)
	else:
		return

func apply_tick(debuff: int) -> void:
	if is_instance_valid(being) and debuff in current_debuffs:
		var dmg: float = DOT[debuff]["dmg_per_tick"]
		SignalBus.emit_signal("apply_dmg_and_debuff", dmg, 0, "debuff", being.name)
		if tick_timers.has(debuff) and not tick_timers[debuff].is_stopped():
			tick_timers[debuff].start()


func call_debuff(debuff: int) -> void:
	match debuff:
		0:
			pass
		1:
			burn()
		2:
			freeze()
		3:
			blindness()
		4:
			slowness()
		5:
			fear()
		6:
			stun()

#IMPORTANT fine tune debuff logic
#region DEBUFFS
func burn() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 5.0
	timer.connect("timeout", remove_debuff.bind(1))
	add_child(timer)
	timer.start()
	print("burning")

func freeze() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 3.0
	timer.connect("timeout", remove_debuff.bind(2))
	add_child(timer)
	timer.start()
	being.stats.speedBUFF = 0.0
	print("frozen: -100% speed")

func blindness() -> void:
	if being.is_in_group("enemy") and get_parent().get_node("NAV").blind_active:
		return
	else:
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = 7.0
		timer.connect("timeout", remove_debuff.bind(3))
		add_child(timer)
		timer.start()
		if being.is_in_group("enemy"):
			get_parent().get_node("NAV").blind_active = true
			print("blind")

func slowness() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 2.0
	timer.connect("timeout", remove_debuff.bind(4))
	add_child(timer)
	timer.start()
	being.stats.speedBUFF = .50
	print("slowed: -50% speed")

func fear() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 3.0
	timer.connect("timeout", remove_debuff.bind(5))
	add_child(timer)
	timer.start()
	if being.is_in_group("enemy"):
		get_parent().get_node("NAV").fear_active = true
		being.stats.speedBUFF = 2.0

func stun() -> void:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.connect("timeout", remove_debuff.bind(6))
	add_child(timer)
	timer.start()
	being.stats.speedBUFF = 0.0
	print("stunned: -100% speed")

#endregion

func remove_debuff(debuff: int) -> void:
	if tick_timers.has(debuff) and is_instance_valid(tick_timers[debuff]):
		tick_timers[debuff].stop()
	remove_queue.append(debuff)
	match debuff:
		0:
			pass
		1:
			pass
		2:
			being.stats.speedBUFF = 1.0
		3:
			if being.is_in_group("enemy"):
				get_parent().get_node("NAV").blind_active = false
				print("blind done")
		4:
			being.stats.speedBUFF = 1.0
		5:
			if being.is_in_group("enemy"):
				get_parent().get_node("NAV").fear_active = false
				being.stats.speedBUFF = 1.0
		6:
			being.stats.speedBUFF = 1.0
