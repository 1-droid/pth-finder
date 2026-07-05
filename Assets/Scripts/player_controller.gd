extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 13.0
@export var side_jump_power = 15.0
@export var climb_speed = 5.0
@export var wall_slide = 1.0

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var reversal = 0

#hitbox setup
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	enemy_attack()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
	
#wall climb
		reversal = Input.get_axis("up", "down")
	if is_on_wall() and (Input.is_action_pressed("wall_stick")):
		if reversal:
			velocity.y = reversal * climb_speed * speed_multiplier
		else:
			velocity.y = move_toward(velocity.y, 0, climb_speed * speed_multiplier)
	
	#handle jump on wall
	if is_on_wall() and Input.is_action_pressed("move_left"):
		velocity.x = side_jump_power
	elif is_on_wall() and Input.is_action_pressed("move_right"):
		velocity.x = -side_jump_power
		
	if health <= 0:
		player_alive = false  #add end screen here
		health = 0
		get_tree().reload_current_scene()

	
	move_and_slide()


	
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false


func enemy_attack():
	if enemy_inattack_range && enemy_attack_cooldown == true:
		health = health - 100
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
