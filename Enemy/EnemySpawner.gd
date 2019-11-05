extends KinematicBody2D

#Stationary enemy that spawns mobile ones up to a cap.

export var spawn_cooldown: float

export var max_units: int
var current_units: int = 0

export var spawn_offset: float
var current_cooldown: float = 0

onready var packed_enemy = preload("res://Enemy/Enemy.tscn")
onready var rng = RandomNumberGenerator.new()

func _process(delta):
	if current_units < max_units and current_cooldown <= 0:
		var new_enemy: KinematicBody2D = packed_enemy.instance()
		var spawn_pos = Vector2((1 + rng.randf()) * spawn_offset, 0)
		new_enemy.position = position + spawn_pos.rotated(rng.randf() * 2 * PI)
		new_enemy.spawner = self
		get_tree().root.add_child(new_enemy)
		current_cooldown = spawn_cooldown
		current_units += 1
	else:
		current_cooldown -= delta

func hit():
	queue_free()
	
func report():
	current_units -= 1