class_name FootSteps extends Node2D
@onready var left_front: Sprite2D = $left_front
@onready var right_front: Sprite2D = $right_front


func _ready() -> void:
	var n: Array = [1,2]
	
	if n.get(randi_range(0,1)) % 2 == 0:
		left_front.visible = false
	else:
		right_front.visible = false
