extends KinematicBody2D

const SPEED = 80
const GRAVITY = 10
const KICKBACK = 400

#   Velocity for movement
var vel = Vector2()
var mouse_pos = Vector2()
#Angle of gun
var angle
#Angel but in vector form
var angle_vector = Vector2()
var one_shot = false

#Project Resolution
var res = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

func _physics_process(delta):
	#Debug
	
	#Movement
	
	#Move right
	if Input.is_action_pressed("ui_right"):
		vel.x += SPEED
	#Move left
	if Input.is_action_pressed("ui_left"):
		vel.x += -SPEED
	
	#Gravity
	if !is_on_floor():
		vel.y += GRAVITY
		one_shot = false
		print("In air")
	elif !one_shot:
		vel.y = 0
		one_shot = true
		print("Stopped Y velocity")
	if is_on_floor():
		#Stop sideways velocity
		vel.x *= .8
	
	#Move
	move_and_slide(vel, Vector2(0, -1))
	
	#Get mouse position relative to player
	mouse_pos = Vector2(get_viewport().get_mouse_position().x - (res.x/2), get_viewport().get_mouse_position().y - (res.y/2))
	
	#RotateGun
	angle = atan2(mouse_pos.x, -mouse_pos.y)*(180/PI)
	angle_vector = Vector2(sin(angle*(PI/180)), cos(angle*(PI/180)))
	$Gun.set_rotation_degrees(angle)

func _input(event):
	#Debug
	"""if event.get_class() != 'InputEventMouseMotion':
		print(event.get_class())"""
	if event.is_action_pressed("ui_shoot"):
		vel += Vector2(-angle_vector.x * KICKBACK, angle_vector.y * KICKBACK)