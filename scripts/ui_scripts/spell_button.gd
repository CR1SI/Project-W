extends TextureButton


@onready var time = $time
@onready var timer = $Timer
@onready var progress_bar = $TextureProgressBar
@onready var key = $key
@onready var h: HBoxContainer = $".."

var change_key = "":
	set(value): 
		change_key = value
		key.text = value
		
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
		
		shortcut.events = [input_key]

var input_spell = 0:
	set(value):
		input_spell = value

func _ready(): 
	change_key = "1"
	progress_bar.max_value = timer.wait_time
	set_process(false)


func _process(_delta): 
	time.text = "%3.1f" % timer.time_left
	progress_bar.value = timer.time_left
	


func _on_pressed():
	SignalBus.connect("spell_fired", Callable(self, "start_cooldown"))
	h.spell_manager.select_spell(input_spell)
	modulate.darkened(50)
	disabled = true

func _on_timer_timeout():
	disabled = false
	time.text = ""
	set_process(false)


func start_cooldown(cooldown):
	SignalBus.disconnect("spell_fired", Callable(self, "start_cooldown"))
	timer.wait_time = cooldown
	progress_bar.max_value = timer.wait_time
	timer.start()
	disabled = true
	set_process(true)
