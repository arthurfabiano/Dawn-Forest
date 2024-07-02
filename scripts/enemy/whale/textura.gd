extends EnemyTexture

class_name WhaleTexture


func animate(velocidade: Vector2) -> void:
	move_behavior(velocidade)
	

func move_behavior(velocidade: Vector2) -> void:
	if velocidade.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	pass
