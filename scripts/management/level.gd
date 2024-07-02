extends Node2D
class_name Level

@onready var player:CharacterBody2D = $Player

func _ready() -> void:
	var game_over:bool = player.get_node("Texture").game_over.connect(on_game_over)
	
	
func on_game_over() -> void:
	var _realod:bool = get_tree().reload_current_scene()
	pass
