extends Sprite2D

class_name PlayerTexture

signal game_over

@onready var animation = $"../Animation"

@export var player: CharacterBody2D
@export var attack_collision:CollisionShape2D

var normal_attack:bool = false
var shield_off:bool = false
var crouching_off:bool = false
var suffix:String = "_right"


func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if player.on_hit or player.dead:
		hit_behavior()
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	pass


func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.target_position = Vector2(11,0)
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"
		player.direction = 1
		position = Vector2(-2,0)
		player.wall_ray.target_position = Vector2(-11,0)


func hit_behavior() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	
	if player.dead:
		animation.play("dead")
	elif player.on_hit:
		animation.play("hit")
	pass


func action_behavior() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix)
	elif player.defending and shield_off:
		animation.play("sheild")
		shield_off = false
	elif player.crouching and crouching_off:
		animation.play("crouch")
		crouching_off = false
	pass


func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	pass

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")
	pass


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
			
		"attack_left":
			normal_attack = false
			player.attacking = false 
			
		"attack_right":
			normal_attack = false
			player.attacking = false
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending:
				animation.play("sheild")
				
			if player.crouching:
				animation.play("crouch")
		
		"dead":
			emit_signal("game_over")
	pass
