extends Control

func _ready() -> void:
	self.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inv") and !self.visible:
		self.visible = true
	elif Input.is_action_just_pressed("inv") and self.visible:
		self.visible = false
