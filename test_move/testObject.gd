extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2()

var rotationSpeed = 0
var rotationBoost = 0.0001
var rotationMaxSpeed = 0.3

var rotationAng = 1
var rot_dir = 1

var maxSpeed = 120
var speedBoost = 0.5
var speed = 0.3

var rotM = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
#	velocity.y = position.y
#	printProps()
	pass

#func _process(delta):
#
#	pass

func moveThisObj(delta):
#	velocity += Vector2(1, 0)
#	print(velocity)
#	velocity.x += velocity.x + 10 * cos(delta)
	velocity = Vector2()
	speed 			= lerp(speed, maxSpeed, speedBoost)
	rotationSpeed 	= lerp(rotationSpeed, rotationMaxSpeed, rotationBoost)
	
	goBySnake()
	
	rotation += rotationSpeed * rot_dir
	
	print(speed)
	
	$Label.text = str(rotation)
	velocity += Vector2(speed, 0).rotated(rotation)
	
	pass

func goBySnake():
	if $Timer.time_left == 0:
		rot_dir = 1
		$Timer.start()

func wrap(value, min_val, max_val):
	var f1 = value - min_val
	var f2 = max_val - min_val
	return fmod(f1, f2) + min_val

func _physics_process(delta):
	moveThisObj(delta)
	move_and_slide(velocity)
#	printProps()
#	$Label.set_rotation(rotation * -1)
#	$Label.rect_global_position = Vector2(position.x - 100, position.y - 100).round()
	$Label.update()
	pass
	
func printProps():
	print("postion	", position)
	print("global postion	", global_position)
	print("rotation	", rotation)
	print("global rotation	", global_rotation)
	print("rotation degres	", rotation_degrees)

func _on_Timer_timeout():
	if rot_dir == 1:
		rot_dir = -1
	else:
		rot_dir = 1
	pass # replace with function body
