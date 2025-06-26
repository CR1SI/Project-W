extends Node2D
class_name effects

@export var rotation_speed: float = 400.0
@export var move_speed: float = 25.0
@export var initial_radius: float = 100
@export var radius_decay: float = 0.5

var current_radius: float

var puller: Node2D
var being_pulled: Node2D

#IMPORTANT ALWAYS ADD IT TO ANY MAIN SCENE

func _ready() -> void:
	SignalBus.do_hitstop.connect(hitstop)
	SignalBus.do_screen_shake.connect(screen_shake)
	SignalBus.pull_inside.connect(pull)
	SignalBus.knockback.connect(knockback)
	
	current_radius = initial_radius

func _physics_process(delta: float) -> void:
	if puller and being_pulled:
		active_pull(delta)
	else:
		return

#FIXME fix knockback
func hitstop() -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, false, false, true).timeout
	Engine.time_scale = 1.0

#TODO add screen shake
func screen_shake() -> void:
	pass

#TODO add knockback
func knockback() -> void:
	pass


#region pulling logic
func pull(pullers: Node2D, being_pulledd:Node2D) -> void:
	self.puller = pullers
	self.being_pulled = being_pulledd

func active_pull(delta: float) -> void:
	var pull_pos: Vector2 = puller.global_position
	var pulled_pos: Vector2 = being_pulled.global_position
	
	var dir: Vector2 = pulled_pos - pulled_pos
	
	var time: float = Time.get_ticks_msec() / 1000.0
	var angle: float = time * rotation_speed
	
	var perpendicular: Vector2 = Vector2(-dir.y, dir.x).normalized()
	var offset: Vector2 = perpendicular * current_radius * sin(angle)
	
	var target_pos: Vector2 = pull_pos + offset
	
	var step: Vector2 = (target_pos - pulled_pos) * delta * move_speed / max(dir.length(), 1.0)
	being_pulled.global_position += step
	
	current_radius *= radius_decay

#endregion
