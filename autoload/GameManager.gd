extends Node


signal score_updated
signal lives_updated
signal powerup_collected(powerup)


export var lives := 3 setget set_lives
export var score := 0 setget set_score
export var blocks := 0
export var level := 1

var sticky_paddle := false


onready var scene_tree := get_tree()


func set_score(_value: int) -> void:
    pass


func set_lives(_value: int) -> void:
    pass


func reset() -> void:
    lives = 3
    score = 0
    level = 1


func register_block() -> void:
    blocks += 1


func destroy_block(_score: int) -> void:
    score += _score
    blocks -= 1
    emit_signal("score_updated")


func score_decrement() -> void:
    score -= 10
    emit_signal("score_updated")


func player_died() -> void:
    sticky_paddle = false
    lives -= 1
    if lives <= 0:
        level = 1
    emit_signal("lives_updated")


func enable_powerup(powerup: int) -> void:
    match powerup:
        Powerup.PowerupTypes.EXTRA_LIFE:
            lives += 1
            emit_signal("lives_updated")
        Powerup.PowerupTypes.STICKY_PADDLE:
            print("enabled sticky")
            sticky_paddle = true
        _:
            emit_signal("powerup_collected", powerup)


func load_main_menu() -> void:
    var _success = scene_tree.change_scene("res://ui/MainMenu.tscn")


func load_next_level() -> bool:
    level += 1
    var success = scene_tree.change_scene("res://levels/Level{level}.tscn".format({"level": level}))
    return success != ERR_CANT_OPEN


func retry() -> void:
    reset()
    scene_tree.paused = false
    var _success = scene_tree.change_scene("res://levels/Level{level}.tscn".format({"level": level}))
