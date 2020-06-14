extends KinematicBody2D
class_name Block


export var score := 100


onready var break_player: AudioStreamPlayer = $BreakSFX
onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var particles: Particles2D = $Particles


var _should_destroy = false


func _ready() -> void:
    GameManager.register_block()


func _physics_process(delta: float) -> void:
    var collision = move_and_collide(Vector2.ZERO)
    if collision:
        _play_collision_fx()
        _on_collision()


func _on_collision() -> void:
    _on_destroy()


func _on_destroy() -> void:
    _should_destroy = true
    GameManager.destroy_block(score)
    sprite.visible = false
    collision_shape.disabled = true


func _play_collision_fx() -> void:
    particles.emitting = true
    break_player.play()


func _on_BreakSFX_finished() -> void:
    if _should_destroy:
        queue_free()
