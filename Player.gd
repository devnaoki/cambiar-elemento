extends KinematicBody2D

export (PackedScene) var ice
export (PackedScene) var fire
export (PackedScene) var thunder

var velocidad = 200
var velocity = Vector2.ZERO

var contador_elemt = 1
var total_elemt = 3
var tipo_elemt


func _ready():
	$AnimatedSprite.play("Idle")
	$AnimatedSprite.playing = true
	tipo_elemt = ice
	$IdenElemento.play("ice")
	
	
	
func _process(_delta):
	CambiarShoot()
	if Input.is_action_just_pressed("ui_accept"):	
		shootIce()
	move()
	velocity = move_and_slide(velocity)
	
func move():
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	
	if velocity.y != 0 or velocity.x != 0:
		$AnimatedSprite.play("Run")
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite.flip_h = true
	elif velocity.y == 0 and velocity.x == 0:
		$AnimatedSprite.play("Idle")
	
	velocity = velocity.normalized() * velocidad
	
	
func CambiarShoot():
	if Input.is_action_just_pressed("cambiar_elemet"):
		if contador_elemt < total_elemt:
			contador_elemt += 1
		else:
			contador_elemt = 1
		
		match contador_elemt:
			1:
				tipo_elemt = ice
				$IdenElemento.play("ice")
			2:
				tipo_elemt = fire
				$IdenElemento.play("fire")
			3:
				tipo_elemt = thunder
				$IdenElemento.play("thunder")

func shootIce():
	var shoot = tipo_elemt.instance()
	if $AnimatedSprite.flip_h:
		$Shoot.scale.x = -1
		shoot.scale = Vector2(-2.3, 2.3)
		shoot.velocidad = -320
	else:
		$Shoot.scale.x = 1
		shoot.scale = Vector2(2.3, 2.3)
		shoot.velocidad = 320
		
	shoot.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Mundo", "add_child", shoot)
