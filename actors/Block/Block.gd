extends KinematicBody2D


func _physics_process(delta: float) -> void:
    var collision = move_and_collide(Vector2.ZERO)
    if collision:
        queue_free()
