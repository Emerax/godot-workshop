extends KinematicBody2D

# Enemy that will path towards the player and reset the game upon contact.

# Movement speed of the enemy.
export var speed: float

var nav: Navigation2D
var player: KinematicBody2D
var spawner

func _ready():
	nav = get_tree().root.get_node("Main/Navigation2D")
	player = get_tree().root.get_node("Main/Tank")

func _physics_process(delta):
	if is_instance_valid(player) and is_instance_valid(nav):
		var path = nav.get_simple_path(position, player.position)
		if path:
			#path[0] is the starting point, we want to go to the next point, hence [1]
			var next_destination = path[1]
			var direction = (next_destination - global_position).normalized() * speed * delta
			move_and_slide(direction)

func hit():
	#This check is not 100% safe as Godot reuses variables. If the spawner has been freed
	#it may be non-valid, or it may be some other object altogether, in which case the attempt to
	#call report() will crash.
	if is_instance_valid(spawner):
		spawner.report()
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.hit()
