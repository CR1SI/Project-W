extends  Node2D
class_name nodes

var player: Player
func _ready() -> void:
    player = get_tree().get_first_node_in_group("player")