extends Node2D

export var paddle_speed: float = 500
export var paddle_limit: float = 438

var balls = []


onready var paddle = $Paddle


func _ready() -> void:
    balls.append($Ball)


func _process(delta: float) -> void:
    var old_paddle_position = paddle.position.x
    var movement = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * delta * paddle_speed
    var new_paddle_position = clamp(old_paddle_position + movement, -paddle_limit, paddle_limit)

    paddle.position.x = new_paddle_position

    if Input.is_action_just_pressed("ui_accept"):
        for ball in balls:
            ball.start_from_paddle(Vector2(-1, -1))
    else:
        for ball in balls:
            ball.move_on_paddle(new_paddle_position - old_paddle_position)


func reset():
    balls[0].reset(paddle.position)


func _on_Ball_killed_by_killbox(ball: Ball) -> void:
    if len(balls) == 1:
        reset()
    else:
        ball.queue_free()
