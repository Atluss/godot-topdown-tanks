extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2()

var rotationSpeed = 0
var rotationBoost = 0.0001
var rotationMaxSpeed = 10

var maxSpeed = 0.4
var speedBoost = 0.002
var speed = 0


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
#	velocity.x -= 1
	speed 			= lerp(speed, maxSpeed, speedBoost)
	rotationSpeed 	= lerp(rotationSpeed, rotationMaxSpeed, rotationBoost)
	
	rotation += rotationSpeed * delta
	
	$Label.text = str(rotation)
	velocity += Vector2(0, 0).rotated(rotation)
	
	pass

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