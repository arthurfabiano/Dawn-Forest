extends Sprite2D

class_name EnemyTexture

@onready var animation:AnimationPlayer = $"../Animation"
@onready var collision = $"../EnemyAttackArea/Collision"

@export var enemy:CharacterBody2D


func animate(_velocidade: Vector2) -> void:
	pass
	

func _on_animation_finished(_anim_name: String):
	pass 
