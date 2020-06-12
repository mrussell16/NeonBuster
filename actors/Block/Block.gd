extends KinematicBody2D


export var score := 100


onready var break_player: AudioStreamPlayer = $BreakSFX
onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
    GameManager.register_block()


func _physics_process(delta: float) -> void:
    var collision = move_and_collide(Vector2.ZERO)
    if collision:
        GameManager.destroy_block(score)
        sprite.visible = false
        collision_shape.disabled = true
        break_player.play()



func _on_BreakSFX_finished() -> void:
    queue_free()
