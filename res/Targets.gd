extends Spatial


var min_height = 5
var max_height = 20

var r = 50

var num_targets = 15

var target_res = preload("res://res/Target/Target.tscn")

func _ready() -> void:
	for i in range(num_targets):
		var y = rand_range(min_height, max_height)
		var x = rand_range(-r, r)
		var z = rand_range(-r, r)
		
		var new_target = target_res.instance()
		new_target.global_transform.origin = Vector3(x, y, z)
		add_child(new_target)
