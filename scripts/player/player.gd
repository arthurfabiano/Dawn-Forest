extends CharacterBody2D

class_name Player

@onready var player_sprite:Sprite2D = $Texture
@onready var wall_ray:RayCast2D = $WallRay
@onready var stats:Node = $Stats

@export var speed:int = 100
@export var jump_speed:int
@export var player_gravity:int
@export var wall_gravity:int
@export var wall_jump_speed:int
@export var wall_impulse_speed:int

var jump_count:int = 0
var landing:bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var on_hit: bool = false
var dead: bool = false

var on_wall:bool = false
var not_on_wall:bool = true
var direction:int = 1 # Inicia com um porque o player começa olhando para direita

var can_track_input:bool = true


func _physics_process(delta: float):
	horizotal_movement_env();
	vertical_movement_env()
	actions_env();
	
	gravity(delta)
	move_and_slide()
	player_sprite.animate(velocity)
	pass


func horizotal_movement_env() -> void:
	var input_direction:float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# Faz com que o personagem não se mova enquanto ataca
	if can_track_input == false or attacking:
		velocity.x = 0
		return
		
	velocity.x = input_direction * speed
	pass


func vertical_movement_env() -> void:
	# Reseta para que o plyer possa pular novamente
	# Se não fosse isso eu não iria conseguir pular novamente
	if is_on_floor() or is_on_wall(): # E na parede
		jump_count = 0
	
	# Faz com que o personagem não se mova enquanto está pulando
	var jump_condition: bool = can_track_input and not attacking
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition:
		jump_count += 1
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
			pass
		else: 
			velocity.y = jump_speed
	pass
	
	
func actions_env() -> void:
	attack()
	crouch()
	defense()
	pass
	
	
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
	pass
	
	
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		stats.shielding = false
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player_sprite.crouching_off = true
		pass
	pass
	
	
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		stats.shielding = true
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
		stats.shielding = false
		player_sprite.shield_off = true
		pass
	pass
	
	
func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
	else:
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
	pass

# Funcao para evitar que vá para cima assim que ele colidir com a parede
func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		# Evita que se ele chegar muito rápido na parede ele já comece subindo
		# Isso iria acontecer porque a velocidade da corrida/forca para cima 
		# está maior que a gravidade pra baixo
		if not_on_wall:
			velocity.y = 0 # Zerando a velocidade para não ir para cima
			not_on_wall = false # Evitar que ele entrar no if novamente
			
		return true
	else:
		not_on_wall = true
		return false
