class_name Player
extends CharacterBody2D

@export var stats: Stats

var mouse_position = null

@onready var spell_manager = $SpellManager
@onready var state_machine: StateMachine = $StateMachine
@onready var idle = $StateMachine/idle
@onready var walk = $StateMachine/walk
@onready var dodge = $StateMachine/dodge
@onready var melee = $StateMachine/melee
@onready var casting = $StateMachine/casting


var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
@onready var character = $character
@onready var animation_player = $AnimationPlayer
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]


func _ready() -> void:
	state_machine.Initialize(self) #initialized statemachine, with self->(player) node
	pass

func _process(_delta: float) -> void:
	#calculating direciton x and y
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	pass

func _physics_process(_delta: float) -> void:
	mouse_position = get_global_mouse_position() #keeps track of mouse position 
	move_and_slide() #check documentation


func setDirection() -> bool:
	if direction == Vector2.ZERO: 
		return false
	
	var direction_id: int = int( round( ( direction ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4 [ direction_id ]
	
	if new_dir == cardinal_direction: 
		return false
	
	cardinal_direction = new_dir
	return true

func UpdateAnimation(state: String) -> void: 
	if state != "idle":
		animation_player.play( state + "_" + AnimDirection())
	else: 
		animation_player.play("idle")
	pass

func AnimDirection() -> String: 
	if cardinal_direction == Vector2.DOWN: 
		return "down"
	elif cardinal_direction == Vector2.UP: 
		return "up"
	elif cardinal_direction == Vector2.RIGHT: 
		return "right"
	else:
		return "left"
