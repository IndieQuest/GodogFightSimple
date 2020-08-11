extends Camera


#########################
# EXPORT PARAMS
#########################
# speed
export (float, 1, 100) var speed = 10
export (float, 1, 3, 0.1) var turbo_modifier = 2
# yaw
export (float, 1, 100) var yaw_speed = 10
export (float, 10, 180, 1) var max_yaw = 70
# roll
export (float, 10, 180, 1) var max_roll = 70
export (float, 1, 100) var pitch_speed = 10
# pitch
export (float, 10, 180, 1) var max_pitch = 30
export (float, 3, 10, 0.5) var turbo_time = 5


#########################
# PARAMS
#########################
onready var model = $Plane
onready var jet_timer = $JetTimer
var is_in_turbo: bool = false


#########################
# OVERRIDE FUNCTIONS
#########################
func _ready() -> void:
	jet_timer.connect("timeout", self, "_turbo_off")


func _process(delta: float) -> void:
	_move(delta)
	_pitch(delta)
	_yaw(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("turbo") and not is_in_turbo:
		_turbo_on()



#########################
# MOVEMENT FUNCTIONS
#########################
func _move(delta: float) -> void:
	var velocity = transform.basis.z * delta * speed
	if is_in_turbo:
		velocity *= turbo_modifier
	translation -= velocity


func _pitch(delta: float) -> void:
	var mouse_speed = _get_mouse_speed()
	rotation_degrees.x += mouse_speed.y * delta * pitch_speed
	var amount = abs(mouse_speed.y)
	var direction = sign(mouse_speed.y)
	model.rotation_degrees.x = lerp(0, max_pitch, amount) * direction


func _yaw(delta: float) -> void:
	var mouse_speed = _get_mouse_speed()
	rotation_degrees.y += mouse_speed.x * delta * pitch_speed
	_roll_and_yaw_model(mouse_speed.x, delta)


func _roll_and_yaw_model(mouse_speed_x: float, delta: float) -> void:
	var amount = abs(mouse_speed_x)
	var direction = sign(mouse_speed_x)
	model.rotation_degrees.y = lerp(0, max_yaw, amount) * direction
	model.rotation_degrees.z = lerp(0, max_roll, amount) * direction


#########################
# HELPER FUNCTIONS
#########################
func _get_mouse_speed() -> Vector2:
	var screen_center = get_viewport().size * 0.5
	var displacment = screen_center - get_viewport().get_mouse_position()
	displacment.x /= screen_center.x
	displacment.y /= screen_center.y
	return displacment


func _turbo_on() -> void:
	is_in_turbo = true
	model.jet_on()
	jet_timer.start(turbo_time)


func _turbo_off() -> void:
	jet_timer.stop()
	is_in_turbo = false
	model.jet_off()

















