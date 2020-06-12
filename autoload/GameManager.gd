extends Node


signal score_updated
signal lives_updated


export var lives := 3 setget set_lives
export var score := 0 setget set_score
export var blocks := 0


func set_score(value: int) -> void:
    pass


func set_lives(value: int) -> void:
    pass


func reset() -> void:
    lives = 3
    score = 0


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
    emit_signal("lives_updated")
