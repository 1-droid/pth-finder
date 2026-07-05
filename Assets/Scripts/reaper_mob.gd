extends CharacterBody2D
@export var speed = 25
var player_chase = false
var player = null

func _physics_process(delta):
	$AnimatedSprite2D.play("walk")
	if player_chase:
		position += (player.position - position) / speed
		
		if (player.position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		if (player.position.x) :
			$AnimatedSprite2D.play("attack")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass
