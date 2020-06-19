extends KinematicBody2D
class_name Powerup


enum PowerupTypes {
    NONE,
    FAST_BALL,
    EXTRA_LIFE,
    TRIPLE_BALL,
    SLOW_PADDLE,
    STICKY_PADDLE
}


export var fall_speed := 100
export(PowerupTypes) var powerup: int = PowerupTypes.FAST_BALL

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var collect_sfx := $CollectSFX


func _physics_process(delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(Vector2.DOWN * fall_speed * delta)
    if collision and collision.collider.name == 'Paddle':
        collect_powerup()


func collect_powerup() -> void:
    GameManager.enable_powerup(powerup)
    collect_sfx.play()
    sprite.visible = false
    collision_shape.disabled = true


func _on_CollectSFX_finished() -> void:
    queue_free()
