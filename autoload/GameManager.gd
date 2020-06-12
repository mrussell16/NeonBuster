extends Node


signal score_updated
signal lives_updated


export var lives := 3 setget set_lives
export var score := 0 setget set_score
export var blocks := 0
export var level := 1
export var total_levels := 2


onready var scene_tree := get_tree()


func set_score(value: int) -> void:
    pass


func set_lives(value: int) -> void:
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
    lives -= 1
    if lives <= 0:
        level = 1
    emit_signal("lives_updated")


func load_next_level() -> void:
    level += 1
    if level <= total_levels:
        scene_tree.change_scene("res://levels/Level{level}.tscn".format({"level": level}))


func retry() -> void:
    reset()
    scene_tree.change_scene("res://levels/Level{level}.tscn".format({"level": level}))
