extends KinematicBody2D

# Player character. A tank with slide-y tank controls and a turret that aims towards the cursor.

export var thrust: float
export var velocity_decay: float
export var reverse_modifier: float
export var rotation_speed: float
export var laser_offset: float

onready var packed_laser = preload("res://Tank/Laser.tscn")
onready var turret: Node = $Turret

var velocity: Vector2

func _physics_process(delta):
	velocity *= velocity_decay
	
	process_input(delta)
	process_mouse()
	
	move_and_slide(velocity)

func process_input(delta: float):
	var acceleration: Vector2
	
	if Input.is_action_pressed("forward"):
		acceleration = Vector2(thrust * delta, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		acceleration = Vector2(-thrust * reverse_modifier * delta, 0).rotated(rotation)
	
	if Input.is_action_pressed("left"):
		rotate(-rotation_speed * delta)
	if Input.is_action_pressed("right"):
		rotate(rotation_speed * delta)
	velocity += acceleration

func process_mouse():
	turret.look_at(get_global_mouse_position())
	if Input.is_action_pressed("fire"):
		var laser: Area2D = packed_laser.instance()
		
		laser.rotate(turret.global_rotation)
		laser.position = turret.global_position + Vector2(laser_offset, 0).rotated(turret.global_rotation)
		
		get_tree().root.add_child(laser)

func hit():
	get_tree().reload_current_scene()