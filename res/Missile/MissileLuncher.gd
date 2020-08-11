extends Spatial


onready var current_missile = $Missile
var loaded: bool = true

onready var reload_timer = $ReloadTimer
var reload_time: float = 5
var missile_res: PackedScene = preload("res://res/Missile/Missile.tscn")


func _ready() -> void:
	reload_timer.connect("timeout", self, "_reload")


func fire(target: Spatial) -> void:
	if not loaded:
		return
	current_missile.fire(target)
	reload_timer.start(reload_time)
	loaded = false


func _reload() -> void:
	reload_timer.stop()
	current_missile = missile_res.instance()
	add_child(current_missile)
	loaded = true
