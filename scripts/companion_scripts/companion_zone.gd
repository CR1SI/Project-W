extends Area2D
class_name companion_zone


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("companion"):
		SignalBus.emit_signal("companion_zone_entered")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("companion"):
		SignalBus.emit_signal("companion_zone_exited")
