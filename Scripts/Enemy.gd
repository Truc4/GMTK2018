extends KinematicBody2D

var type = 'Enemy'

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	#Temporary
	move_and_slide(Vector2(0, 500))