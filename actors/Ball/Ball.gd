extends KinematicBody2D
class_name Ball


signal killed_by_killbox(ball)


export var movement_speed: float = 400


var velocity: Vector2 = Vector2.ZERO
var on_paddle: bool = true
var index_on_player: int = 0


func start_from_paddle(direction: Vector2) -> void:
    if on_paddle:
        velocity = direction.normalized() * movement_speed
        on_paddle = false


func move_on_paddle(movement: float) -> void:
    if on_paddle:
        position.x += movement

func on_killbox_enter():
    emit_signal("killed_by_killbox", self)


func reset(paddle_position: Vector2):
    position = paddle_position + Vector2(0, -16)
    on_paddle = true
    velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(velocity * delta)
    if collision:
        # TODO: Detect if near edge of paddle and apply tweaking to angle
        # if collision.collider.name == 'Paddle':
        if abs(collision.normal.x) > 0.1:
            velocity.x = -velocity.x
        elif abs(collision.normal.y) > 0.1:
            velocity.y = -velocity.y
