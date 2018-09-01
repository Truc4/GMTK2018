extends Node

var enemy_resource = preload("res://Scenes/Enemy.tscn")
var enemy
var level = 1

func _ready():
	randomize()
	pass

func _process(delta):
	#Debug
	"""if randi()%100 == 1:
		enemy = enemy_resource.instance()
		enemy.set_position(Vector2((randf()*1000)-500, (randf()*1000)-500))
		get_node("Level1").add_child(enemy)"""
	pass

func next_level():
	get_node("Level" + str(level)).queue_free()
	level += 1
	add_child(load("res://Scenes/Level" + str(level) + ".tscn").instance())
	get_node("Player").reset()