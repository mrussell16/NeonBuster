extends Control


enum HUDState {
    STATE_PAUSED,
    STATE_WIN,
    STATE_LOSE
}


const SCORE_TEMPLATE := "Score: {score}"
const LIVES_TEMPLATE := "Lives: {lives}"
const PAUSE_LEVEL_TEMPLATE := "Level: {level}"
const PAUSE_SCORE_TEMPLATE := "Your Score: {score}"
const PAUSE_LIVES_TEMPLATE := "Lives Remaining: {lives}"


var paused_text: Texture = preload("res://ui/text/Paused.png")
var game_over_text: Texture = preload("res://ui/text/GameOver.png")
var you_win_text: Texture = preload("res://ui/text/YouWin.png")
var paused := false setget set_paused
var game_end := false setget set_paused


onready var scene_tree := get_tree()
onready var pause_overlay: ColorRect = $PauseOverlay
onready var score_label: Label = $Score
onready var lives_label: Label = $Lives
onready var pause_title: TextureRect = $PauseOverlay/Menu/Title
onready var pause_level_label: Label = $PauseOverlay/Menu/Level
onready var pause_score_label: Label = $PauseOverlay/Menu/Score
onready var pause_lives_label: Label = $PauseOverlay/Menu/Lives
onready var retry_button: Node = $PauseOverlay/Menu/RetryButton
onready var continue_button: Node = $PauseOverlay/Menu/ContinueButton


func _ready() -> void:
    var _connect = GameManager.connect("score_updated", self, "_on_score_updated")
    var _connect2 = GameManager.connect("lives_updated", self, "_on_lives_updated")
    pause_level_label.text = PAUSE_LEVEL_TEMPLATE.format({"level": GameManager.level})
    score_label.text = SCORE_TEMPLATE.format({"score": GameManager.score})
    pause_score_label.text = PAUSE_SCORE_TEMPLATE.format({"score": GameManager.score})
    lives_label.text = LIVES_TEMPLATE.format({"lives": GameManager.lives})
    pause_lives_label.text = PAUSE_LIVES_TEMPLATE.format({"lives": GameManager.lives})


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause") and not game_end:
        set_paused(not paused)
        scene_tree.set_input_as_handled()


func set_paused(value: bool, state: int = HUDState.STATE_PAUSED) -> void:
    paused = value
    scene_tree.paused = value
    pause_overlay.visible = value
    score_label.visible = not value
    lives_label.visible = not value
    if state != HUDState.STATE_PAUSED:
        game_end = true

    match state:
        HUDState.STATE_WIN:
            game_end = true
            pause_title.texture = you_win_text
        HUDState.STATE_LOSE:
            game_end = true
            pause_title.texture = game_over_text
        _:
            game_end = false
            pause_title.texture = paused_text

    continue_button.visible = state != HUDState.STATE_LOSE and state != HUDState.STATE_WIN
    retry_button.visible = state == HUDState.STATE_LOSE


func _on_score_updated() -> void:
    score_label.text = SCORE_TEMPLATE.format({"score": GameManager.score})
    pause_score_label.text = PAUSE_SCORE_TEMPLATE.format({"score": GameManager.score})

    if GameManager.blocks == 0:
        if not GameManager.load_next_level():
            set_paused(true, HUDState.STATE_WIN)


func _on_lives_updated() -> void:
    lives_label.text = LIVES_TEMPLATE.format({"lives": GameManager.lives})
    pause_lives_label.text = PAUSE_LIVES_TEMPLATE.format({"lives": GameManager.lives})

    if GameManager.lives <= 0:
        set_paused(true, HUDState.STATE_LOSE)


func _on_ContinueButton_pressed() -> void:
    set_paused(false)
