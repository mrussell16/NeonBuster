extends Node2D

export var paddle_speed :=  500
export var ball_speed :=  400
export var initial_ball_speed :=  400
export var level_size :=  1024
export var wall_width :=  16
export var paddle_width :=  128
export var spin_distance :=  32

export(PackedScene) var ball_scene

var balls = []
var paddle_limit :=  128


onready var paddle = $Paddle
onready var timer = $Timer
onready var death_sfx = $DeathSFX


func _ready() -> void:
    _create_ball(global_position + Vector2(0, -16))
    var _connected = GameManager.connect("powerup_collected", self, "_on_powerup_collected")

    paddle_limit = (level_size - wall_width - wall_width - paddle_width) / 2


func _process(delta: float) -> void:
    var old_paddle_position = paddle.position.x
    var movement = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * delta * paddle_speed
    var new_paddle_position = clamp(old_paddle_position + movement, -paddle_limit, paddle_limit)

    paddle.position.x = new_paddle_position

    if Input.is_action_just_pressed("ui_accept"):
        for ball in balls:
            ball.start_from_paddle(Vector2(-1, -1))
        timer.start()
    else:
        for ball in balls:
            ball.move_on_paddle(new_paddle_position - old_paddle_position)


func reset():
    balls[0].reset(paddle.position)
    ball_speed = initial_ball_speed
    set_ball_settings()
    timer.stop()


func set_ball_settings():
    for ball in balls:
        ball.set_params(ball_speed, paddle_width, spin_distance)


func _on_Ball_killed_by_killbox(ball: Ball) -> void:
    if len(balls) == 1:
        GameManager.player_died()
        death_sfx.play()
        reset()
    else:
        balls.erase(ball)
        ball.queue_free()


func _on_Timer_timeout() -> void:
    GameManager.score_decrement()
    ball_speed += 2
    set_ball_settings()
    timer.start()


func _on_powerup_collected(powerup: int) -> void:
    match powerup:
        Powerup.PowerupTypes.FAST_BALL:
            ball_speed += 200
            set_ball_settings()
        Powerup.PowerupTypes.TRIPLE_BALL:
            _triple_balls()


func _triple_balls() -> void:
    var balls_to_clone = len(balls)
    for index in range(balls_to_clone):
        var ball = balls[index]
        _create_ball(ball.global_position, Vector2(ball.velocity.x * 2, ball.velocity.y), false)
        _create_ball(ball.global_position, Vector2(ball.velocity.x, ball.velocity.y * 2), false)


func _create_ball(position: Vector2, velocity: Vector2 = Vector2.ZERO, on_paddle: bool = true) -> void:
    var new_ball = ball_scene.instance()
    add_child(new_ball)
    new_ball.global_position = position
    new_ball.set_params(ball_speed, paddle_width, spin_distance)
    var _connected = new_ball.connect("killed_by_killbox", self, "_on_Ball_killed_by_killbox")
    if not on_paddle:
        new_ball.start_from_paddle(velocity.normalized())
    balls.append(new_ball)
