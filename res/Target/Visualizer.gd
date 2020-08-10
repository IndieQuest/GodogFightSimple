extends Spatial


export var rotation_speed: float = 30
var time: float = 0


func _physics_process(delta: float) -> void:
	rotation_degrees.y += rotation_speed * delta
	
	time += delta
	translation.y = sin(time * PI) * 0.5 
