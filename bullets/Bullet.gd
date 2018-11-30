extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime = 0.4
export (float) var steer_force = 0

var acceleration = Vector2()
var target = null
var velocity = Vector2()

func _ready():
	$Lifetime.wait_time = lifetime

func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	target = _target
	$Lifetime.start()

func _process(delta):
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer

func explode_bullet():
	set_process(false)
	velocity = Vector2()
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")

func _on_Bullet_body_entered(body):
	explode_bullet()
	if body.has_method('take_damage'):
		body.take_damage(damage)

func _on_Lifetime_timeout():
	explode_bullet()

func _on_Explosion_animation_finished():
	queue_free()

func _on_Bullet_area_entered(body):
	if body.has_method('explode_bullet'):
		body.explode_bullet()
		explode_bullet()
	pass # replace with function body
