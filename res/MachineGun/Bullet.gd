extends RigidBody
class_name Bullet

##############################
# EXPORT PARAMS
##############################
export var lifetime: float = 2


##############################
# FUNCTIONS
##############################
func fire(muzzle_velocity: float) -> void:# create timer and set queue_free on timeout
	var death_timer = Timer.new()
	add_child(death_timer)
	death_timer.connect("timeout", self, "queue_free")
	death_timer.start(lifetime)
	# fire
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * muzzle_velocity)
