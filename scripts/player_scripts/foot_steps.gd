class_name FootSteps extends Node2D
@onready var left_front: Sprite2D = $left_front
@onready var right_front: Sprite2D = $right_front
@onready var stepId: int

func _ready() -> void:
	if stepId % 2 == 0:
		left_front.visible = false
	else:
		right_front.visible = false
