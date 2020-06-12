extends KinematicBody2D
class_name Ball


signal killed_by_killbox(ball)
signal collided_with_paddle()


export var movement_speed := 400
export var spin_distance := 20
export var paddle_width := 128


var velocity := Vector2.ZERO
var on_paddle := true
var half_paddle_width := 0
var spin_start := 0


onready var bounce_player: AudioStreamPlayer = $BounceSFX


func _ready() -> void:
    half_paddle_width = paddle_width / 2
    spin_start = half_paddle_width - spin_distance


func set_params(ball_speed: int, paddle_width: int, spin_distance: int) -> void:
    movement_speed = ball_speed
    paddle_width = paddle_width
    spin_distance = spin_distance
    half_paddle_width = paddle_width / 2
    spin_start = half_paddle_width - spin_distance


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


func _handle_paddle_collision(collision: KinematicCollision2D):
    var position_difference = collision.position.x - collision.collider.global_position.x
    var new_velocity = Vector2(0, -1)
    if position_difference > spin_start:
        new_velocity.x = 1 + (position_difference - spin_start) / spin_distance
    elif position_difference < -spin_start:
        new_velocity.x = -1 + (position_difference + spin_start) / spin_distance
    else:
        new_velocity.x = sign(velocity.x)

    velocity = new_velocity.normalized() * movement_speed


func _physics_process(delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(velocity * delta)
    if collision:
        bounce_player.play()
        if collision.collider.name == 'Paddle':
            _handle_paddle_collision(collision)
        else:
            if abs(collision.normal.x) > 0.1:
                velocity.x = -velocity.x
            elif abs(collision.normal.y) > 0.1:
                velocity.y = -velocity.y
