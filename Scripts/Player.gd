extends KinematicBody2D

const SPEED = 70
const GRAVITY = 10
const KICKBACK = 500
const GROUND_FRICTION = .8
const AIR_FRICTION = .98
const WALL_FRICTION = .6
const MAX_HEALTH = 6

var bullet_resource = preload("res://Scenes/Bullet.tscn")
var bullet

onready var health = get_node("UI/Health")

#   Velocity for movement
var vel = Vector2()
var mouse_pos = Vector2()
#Angle of gun
var angle
#Angel but in vector form
var angle_vector = Vector2()

#Project Resolution
var res

#To flash colors
var color = Color(1,1,1,1)

var bullet_angle
var bullet_angle_vector

var player_viewport_pos = Vector2()

func _ready():
	health.value = MAX_HEALTH
	reset()

func _physics_process(delta):
	#Debug
	#print($PlayerSprite.get_modulate())
	#print(get_viewport_rect())

	#Death plane
	if get_position().y > 2000:
		die()

	#Resolution
	res = get_viewport_rect().size

	#Movement

	#Move right
	if Input.is_action_pressed("ui_right") and vel.x < SPEED*2:
		if is_on_floor():
			vel.x += SPEED
		else:
			vel.x += SPEED*.1
	#Move left
	if Input.is_action_pressed("ui_left") and vel.x > -SPEED*2:
		if is_on_floor():
			vel.x += -SPEED
		else:
			vel.x += -SPEED*.1
	
	#Gravity
	vel.y += GRAVITY
	
	#Move
	move_and_slide(vel, Vector2(0, -1))
	
	#On floor
	if is_on_floor():
		vel.y = 0
		if $Reload.is_stopped() or $Reload.time_left < .8:
			vel.x *= GROUND_FRICTION
	else:
		vel.x *= AIR_FRICTION
	#On wall
	if is_on_wall():
		vel.x += (abs(vel.x) / vel.x) * WALL_FRICTION
	#On ceiling
	if is_on_ceiling() and vel.y < 0:
		vel.y = 0

	#Get mouse position relative to  player
	mouse_pos = get_viewport().get_mouse_position() - self.get_global_transform_with_canvas().get_origin()
	#Get mouse position relative to center of screen
	#mouse_pos = Vector2(get_viewport().get_mouse_position().x - (res.x/2) - player_viewport_pos.x, get_viewport().get_mouse_position().y - (res.y/2) - player_viewport_pos.y)

	#RotateGun
	angle = atan2(mouse_pos.x, -mouse_pos.y)*(180/PI)
	angle_vector = Vector2(sin(angle*(PI/180)), cos(angle*(PI/180)))
	$Gun.set_rotation_degrees(angle)

	#White flash
	get_node("PlayerSprite").modulate = color
	if color.r > 1:
		color.r *= .8
	if color.g > 1:
		color.g *= .8
	if color.b > 1:
		color.b *= .8
	color.a = 1

	#Collision with objects
	if $Area2D.get_overlapping_bodies().size() > 1:
		for body in $Area2D.get_overlapping_bodies():
			if body.name != 'Player':
				if body.get_class() == 'KinematicBody2D' and body.type == 'Enemy':
					damage()
				if body.name == 'Spikes':
					damage()
				"""if body.name == 'Goal':
					get_parent().next_level()"""

func _input(event):
	#Debug
	"""if event.get_class() != 'InputEventMouseMotion':
		print(event.get_class())"""
	if event.is_action_pressed("ui_shoot"):
		if $Reload.is_stopped():
			$Reload.start()
			shoot()

func shoot():
	vel += Vector2(-angle_vector.x * KICKBACK, -abs(angle_vector.y) * KICKBACK)
	bullet = bullet_resource.instance()
	bullet.set_position(get_position())
	bullet.angle = angle
	bullet.angle_vector = Vector2(angle_vector.x, -angle_vector.y)
	for node in get_parent().get_children():
		if node.get_class() == 'TileMap':
			node.add_child(bullet)

func _on_Reload_timeout():
	#Flash white
	color = Color(10, 10, 10, 1)

func die():
	health.value = MAX_HEALTH
	health.set_visible(false)
	reset()

func reset():
	set_position(Vector2(0,0))
	vel = Vector2(0,0)

func damage():
	if $InvincibilityFrames.is_stopped():
		color = Color(10,1,1,1)
		health.value -= 1
		health.set_visible(true)
		if health.value <= 0:
			die()
		$InvincibilityFrames.start()