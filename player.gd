extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	# 1. Comprobar entradas
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	# Normalizar para evitar movimiento más rápido en diagonales
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# 2. Mover al jugador
	position += velocity * delta

	# 3. Reproducir animación apropiada (ejemplo simplificado)
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite.play("walk")
		# Puedes cambiar la animación según dirección
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("idle")
