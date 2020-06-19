extends Area2D
class_name BlockPass


export var score := 50
export(PackedScene) var powerup


onready var break_player: AudioStreamPlayer = $BreakSFX
onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var particles: Particles2D = $Particles


var _should_destroy = false


func _ready() -> void:
    GameManager.register_block()


func _on_body_entered(_body: Node) -> void:
    if not _should_destroy:
        _on_collision()


func _on_collision() -> void:
    _play_collision_fx()
    _on_destroy()


func _on_destroy() -> void:
    _should_destroy = true
    create_powerup()
    GameManager.destroy_block(score)
    sprite.visible = false
    collision_shape.disabled = true


func create_powerup() -> void:
    if powerup:
        var powerup_instance = powerup.instance()
        powerup_instance.global_position = global_position
        get_parent().add_child(powerup_instance)


func _play_collision_fx() -> void:
    particles.emitting = true
    break_player.play()


func _on_BreakSFX_finished() -> void:
    if _should_destroy:
        queue_free()
