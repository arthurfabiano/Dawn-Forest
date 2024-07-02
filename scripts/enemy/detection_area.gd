extends Area2D

class_name DetectionArea

@export var enemy: CharacterBody2D


func _on_body_entered(body: Player) -> void:
	enemy.player_ref = body
	pass


func _on_body_exited(_body: Player) -> void:
	enemy.player_ref = null
	pass
