extends KinematicBody2D

const SPEED = 500

var angle
var angle_vector

func _ready():
	set_rotation_degrees(angle)

func _physics_process(delta):
	move_and_slide(angle_vector*SPEED)
	for body in $Area2D.get_overlapping_bodies():
		if body and body.name != 'Player':
			if body.get_class() == 'KinematicBody2D' and body.type == 'Enemy':
<<<<<<< HEAD
				get_node("../../Player").color = Color(10,10,10,1)
				get_node("../../Player/Reload").stop()
=======
				get_node("../Player").color = Color(10,10,10,1)
				get_node("../Player/Reload").stop()
>>>>>>> 1d3f535bff2c25a7f75e3d8841e0756917b35ee8
				body.queue_free()
			queue_free()

func _on_Life_timeout():
	queue_free()