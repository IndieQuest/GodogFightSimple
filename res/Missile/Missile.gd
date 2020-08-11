extends Area


############################
# EXPORT PARAMS
############################
export var lifetime: float = 2
export var steer_force: float = 30
export var speed: float = 50


############################
# PARAMS
############################
var velocity: Vector3
var target: Spatial


############################
# OVERRIDE FUNCTIONS
############################
func _physics_process(delta: float) -> void:
	if target == null:
		return
	# get updated target ,location
	var target_location = target.global_transform.origin
	# get desiered velocity
	var desiered_velocity = (target_location - transform.origin).normalized() * speed
	# get diff in velocity
	var steer = (desiered_velocity - velocity).normalized() * steer_force
	# update velocity
	velocity += steer * delta
	# look at movement
	look_at(transform.origin + velocity, Vector3.UP)
	# move
	translation += velocity * delta


############################
# FUNCTIONS
############################
func fire(target: Spatial) -> void:
	self.target = target
	$CollisionShape.disabled = false
	$Jet.emitting = true
	$LunchSound.play()
	set_as_toplevel(true)
	velocity = -transform.basis.z * 0.2 * speed
	yield(get_tree().create_timer(lifetime), "timeout")
	_explode()


func _explode() -> void:
	queue_free()


############################
# EVENTS HANDALING
############################
func _on_Missile_area_shape_entered(area_id: int, area: Area, area_shape: int, self_shape: int) -> void:
	if area.is_in_group("Targets"):
		_explode()


func _on_Missile_body_entered(body: Node) -> void:
	if body.is_in_group("Targets"):
		_explode()






















