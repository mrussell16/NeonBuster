extends Node2D

export var paddle_speed :=  500
export var ball_speed :=  400
export var level_size :=  1024
export var wall_width :=  16
export var paddle_width :=  128
export var spin_distance :=  32


var balls = []
var paddle_limit :=  128


onready var paddle = $Paddle


func _ready() -> void:
    balls.append($Ball)
    set_ball_settings()

    paddle_limit = (level_size - wall_width - wall_width - paddle_width) / 2


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


func set_ball_settings():
    for ball in balls:
        ball.set_params(ball_speed, paddle_width, spin_distance)


func _on_Ball_killed_by_killbox(ball: Ball) -> void:
    if len(balls) == 1:
        GameManager.player_died()
        reset()
    else:
        ball.queue_free()
