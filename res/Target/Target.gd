extends Area


var life = 5


func _explode() -> void:
	$Explotion.explode()
	$Visualizer.hide()
	$CollisionShape.disabled = true
	$ExplotionSound.play()
	$PointSound.play()
	Events.emit_signal("target_destroyed")
	Events.emit_signal("target_released")


func _hit() -> void:
	life -= 1
	if life <= 0:
		_explode()
	else:
		$HitSound.play()


func _on_Target_body_entered(body: Node) -> void:
	if body.is_in_group("Bullets"):
		_hit()


func _on_Target_area_entered(area: Area) -> void:
	if area.is_in_group("Missiles"):
		_explode()


func _on_Target_mouse_entered() -> void:
	Events.emit_signal("target_locked", self)


func _on_Target_mouse_exited() -> void:
	Events.emit_signal("target_released")
