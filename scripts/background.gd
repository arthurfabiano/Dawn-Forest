extends ParallaxBackground

class_name background

@export var can_process: bool
@export var layer_speed: Array[int]
@export var player: CharacterBody2D

func _ready():
	if can_process == false:
		set_physics_process(false) # deixa de processa a função physics_process
		pass

func _process(delta):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			if player.velocity.x < 0:
				get_child(index).motion_offset.x += layer_speed[index] * delta
			elif player.velocity.x > 0:
				get_child(index).motion_offset.x -= layer_speed[index] * delta
	pass
