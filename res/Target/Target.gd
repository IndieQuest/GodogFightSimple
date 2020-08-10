extends Area


func _explode() -> void:
	$Explotion.explode()
	$Visualizer.hide()
	$CollisionShape.disabled = true
	$ExplotionSound.play()


func _on_Target_body_entered(body: Node) -> void:
	pass


func _on_Target_area_entered(area: Area) -> void:
	if area.is_in_group("Missiles"):
		_explode()
