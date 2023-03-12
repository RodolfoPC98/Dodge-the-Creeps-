extends Area2D
signal hit

export var speed = 400 #Qué tan rápido se moverá el jugador (píxeles/seg). 
# se exporta como una caracteristica de panel de herramientas
var screen_size # Tamaño de la ventana del juego$AnimatedSprite 


func _ready(): #funciona principal o metodo principal
	screen_size = get_viewport_rect().size
	#hide()

func _process(delta):
	
	# Movimiento del personaje (teclas)
	var velocity = Vector2.ZERO #El vector de movimiento del jugador
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
		# Normaliza la velocidad del personaje de forma diagonal
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
		
	
	#Esta parte delimita el alcance del personaje al tamaño del cuadro
	#Aplicar clamp es restringir un valor a un determinado rango
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	 #Establece la orientacion del personaje al moverse
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	
	

		
	
func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Debe posponerse ya que no podemos cambiar las propiedades físicas
	# en una devolución de llamada de física. (Descripción que da godot)
	# get_node("CollisionShape2D").set_deferred("disabled",true)
	# Cada vez que un enemigo golpea al jugador, la señal será emitida. 
	# Necesitamos deshabilitar la colisión del jugador para que no activemos
	# la señal de hit más de una vez.
	$CollisionShape2D.set_deferred("disabled", false)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
