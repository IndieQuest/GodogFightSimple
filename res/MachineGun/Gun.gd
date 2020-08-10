extends Spatial
class_name Gun

###############################
# EXPORT PARAMS
###############################
# fire mode
export var autofire: bool = true
# which action triggers fire
export var listem_to_input: bool = false
export var fire_action_name: String
# bullet info
export var bullet_res: PackedScene
export var muzzle_velocity: float
export var fire_rate: float = 10
# sounds
export var wait_for_sound: bool = false
export var fire_sound: AudioStream
export var reload_sound: AudioStream


###############################
# PARAMS
###############################
# delay time
onready var fire_delay = 1.0 / fire_rate
var delay_timer: Timer
# fire mode
var can_fire = true
# sound players
var fire_sound_player: AudioStreamPlayer
var reload_sound_player: AudioStreamPlayer


###############################
# OVERRIDE FUNCTINOS
###############################
func _ready() -> void:
	# create fire delay timer
	delay_timer = Timer.new()
	if autofire:
		delay_timer.connect("timeout", self, "_fire")
	else:
		delay_timer.connect("timeout", self, "_reload")
	add_child(delay_timer)
	# create fire audio stream
	fire_sound_player = AudioStreamPlayer.new()
	fire_sound_player.stream = fire_sound
	add_child(fire_sound_player)
	# create reload audio stream
	reload_sound_player = AudioStreamPlayer.new()
	reload_sound_player.stream = reload_sound
	add_child(reload_sound_player)


func _input(event: InputEvent) -> void:
	if not listem_to_input:
		return
	if event.is_action_pressed(fire_action_name):
		open_fire()
	if event.is_action_released(fire_action_name) and autofire:
		cease_fire()


###############################
# FUNCTIONS
###############################
func open_fire() -> void:
	if autofire or can_fire:
		_fire()
#		if not fire_sound_player.playing:
		fire_sound_player.playing = true
		if wait_for_sound:
			yield(fire_sound_player, "finished")


func cease_fire() -> void:
	fire_sound_player.playing = false
	delay_timer.stop()


func _reload() -> void:
	delay_timer.stop()
	if reload_sound:
		reload_sound_player.play()
		if wait_for_sound:
			yield(reload_sound_player, "finished")
	can_fire = true
	reload_sound_player.playing = false


func _fire() -> void:
	if bullet_res != null:
		can_fire = false
		var new_bullet = bullet_res.instance()
		add_child(new_bullet)
		new_bullet.fire(muzzle_velocity)
		# start reload timer
		delay_timer.start(fire_delay)
