extends Spatial


var aim_distance = 100

onready var jet = $Jet
onready var jet_sound = $JetSound
onready var camera = get_parent()
onready var bore_sight = $BoreSight
onready var half_bore_dim = bore_sight.rect_size * 0.5


var target: Spatial
onready var demi_target: Spatial = $DemiTarget


var default_curser = preload("res://Assets/Images/SteeringCurser.png")
var locked_curser = preload("res://Assets/Images/LockTarget.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(default_curser, 0, Vector2(18, 18))
	Events.connect("target_locked", self, "_target_locked")
	Events.connect("target_released", self, "_target_released")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_missile"):
		_fire_missile()


func _process(delta: float) -> void:
	var world_aim_pos = global_transform.origin - global_transform.basis.z * aim_distance
	var bore_sight_pos = camera.unproject_position(world_aim_pos) - half_bore_dim
	bore_sight.rect_position = bore_sight_pos


func jet_on() -> void:
	jet.emitting = true
	jet_sound.playing = true


func jet_off() -> void:
	jet.emitting = false
	jet_sound.playing = false


func _get_target() -> Spatial:
	if target != null:
		return target
	else:
		return demi_target


func _fire_missile() -> void:
	for c in $Missiles.get_children():
		if c.loaded:
			c.fire(_get_target())
			return


func _target_locked(new_target: Spatial) -> void:
	target = new_target
	$LockSound.playing = true
	Input.set_custom_mouse_cursor(locked_curser, 0, Vector2(18, 18))


func _target_released() -> void:
	target = null
	$LockSound.playing = false
	Input.set_custom_mouse_cursor(default_curser, 0, Vector2(18, 18))
