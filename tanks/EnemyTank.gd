extends "res://tanks/Tank.gd"

var speed = 0

var envintormentLayer = 0
var enemyLayer = 2

onready var parent = get_parent()

export (float) var turret_speed
export (int) var detect_radius

var target = null

func _ready():
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func control(delta):
	if parent is PathFollow2D:
		if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
			speed = lerp(speed, 0, 0.1)
		else:
			speed = lerp(speed, max_speed, 0.05)
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
		if target:
			velocity = Vector2()
			var rot_dir = 0
			var collider  = null
			var collider1 = null
			var collider2 = null
			
			if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
				
				collider1 = $LookAhead1.get_collider()
				collider2 = $LookAhead2.get_collider()
				
				if (collider1 != null and collider1.get_collision_layer_bit(envintormentLayer)) or (collider2 != null and collider2.get_collision_layer_bit(envintormentLayer)):
						
					if $LookAhead1.is_colliding() and $LookAhead2.is_colliding():
						
						speed = lerp(speed, -max_speed/1.3, 0.20)
						rotation += rotation_speed * rot_dir * delta
						velocity += Vector2(speed, 0).rotated(rotation)
					else:
						
						if $LookAhead1.is_colliding():
							collider = $LookAhead1.get_collider()
						elif $LookAhead2.is_colliding():
							collider = $LookAhead2.get_collider()

						rot_dir = (collider.global_position - global_position).normalized()

#						print(rot_dir)
						
						rotation += rotation_speed * delta
						velocity += Vector2(speed, 0).rotated(rotation)
				else:
					if (collider1 != null and collider1.get_collision_layer_bit(enemyLayer)) or (collider2 != null and collider2.get_collision_layer_bit(enemyLayer)):
						speed = lerp(speed, -max_speed/2, 0.05)
					else:
						speed = lerp(speed, 0, 0.6)

					velocity += Vector2(speed, 0).rotated(global_rotation)
				
			else:
				var target_dir = (target.global_position - global_position).normalized()
				var current_dir = Vector2(1, 0).rotated(global_rotation)
				global_rotation = current_dir.linear_interpolate(target_dir, rotation_speed * delta).angle()
#				if abs(target_dir.dot(current_dir)) > 0.8:
#					speed = lerp(speed, max_speed, 0.01)
#				else:
#					speed = lerp(speed, 0, 0.1)
				speed = lerp(speed, max_speed, 0.01)
				velocity += Vector2(speed, 0).rotated(global_rotation)
	
		else:
			speed = lerp(speed, 0, 0.7)
	pass

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot(gun_shots, gun_spread, target)

func _on_DetectRadius_body_entered(body):
	target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null