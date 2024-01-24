extends Area2D

class_name Crate

signal crate_collision(body)



func _on_body_entered(body):
	crate_collision.emit(body)
