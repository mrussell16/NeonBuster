extends KinematicBody2D


export var score := 100


func _ready() -> void:
    GameManager.register_block()


func _physics_process(delta: float) -> void:
    var collision = move_and_collide(Vector2.ZERO)
    if collision:
        GameManager.destroy_block(score)
        queue_free()
