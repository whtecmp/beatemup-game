extends Area2D


func _on_attack_detector_body_entered(body):
	emit_signal("object_entered_attack_range", get_node("."), body)
