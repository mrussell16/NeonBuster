extends Control


const LOSE_MESSAGE := "Game Over"
const WIN_MESSAGE := "You Win"
const SCORE_TEMPLATE := "Score: {score}"
const LIVES_TEMPLATE := "Lives: {lives}"
const PAUSE_LEVEL_TEMPLATE := "Level: {level}"
const PAUSE_SCORE_TEMPLATE := "Your Score: {score}"
const PAUSE_LIVES_TEMPLATE := "Lives Remaining: {lives}"


var paused := false setget set_paused


onready var scene_tree := get_tree()
onready var pause_overlay: ColorRect = $PauseOverlay
onready var score_label: Label = $Score
onready var lives_label: Label = $Lives
onready var pause_title: Label = $PauseOverlay/Menu/Title
onready var retry_button: Button = $PauseOverlay/Menu/Retry
onready var continue_button: Button = $PauseOverlay/Menu/Continue
onready var pause_level_label: Label = $PauseOverlay/Menu/Level
onready var pause_score_label: Label = $PauseOverlay/Menu/Score
onready var pause_lives_label: Label = $PauseOverlay/Menu/Lives


func _ready() -> void:
    GameManager.connect("score_updated", self, "_on_score_updated")
    GameManager.connect("lives_updated", self, "_on_lives_updated")
    pause_level_label.text = PAUSE_LEVEL_TEMPLATE.format({"level": GameManager.level})
    score_label.text = SCORE_TEMPLATE.format({"score": GameManager.score})
    pause_score_label.text = PAUSE_SCORE_TEMPLATE.format({"score": GameManager.score})
    lives_label.text = LIVES_TEMPLATE.format({"lives": GameManager.lives})
    pause_lives_label.text = PAUSE_LIVES_TEMPLATE.format({"lives": GameManager.lives})


func _unhandled_input(event: InputEvent) -> void:
    if (
        event.is_action_pressed("pause") and
        pause_title.text != LOSE_MESSAGE and
        pause_title.text != WIN_MESSAGE
    ) :
        set_paused(not paused)
        scene_tree.set_input_as_handled()


func set_paused(value: bool, title: String = 'Paused') -> void:
    paused = value
    scene_tree.paused = value
    pause_overlay.visible = value
    score_label.visible = not value
    lives_label.visible = not value
    pause_title.text = title

    continue_button.visible = title != LOSE_MESSAGE and title != WIN_MESSAGE
    retry_button.visible = title == LOSE_MESSAGE


func _on_score_updated() -> void:
    score_label.text = SCORE_TEMPLATE.format({"score": GameManager.score})
    pause_score_label.text = PAUSE_SCORE_TEMPLATE.format({"score": GameManager.score})

    if GameManager.blocks == 0:
        if GameManager.level < GameManager.total_levels:
            GameManager.load_next_level()
        else:
            set_paused(true, WIN_MESSAGE)


func _on_lives_updated() -> void:
    lives_label.text = LIVES_TEMPLATE.format({"lives": GameManager.lives})
    pause_lives_label.text = PAUSE_LIVES_TEMPLATE.format({"lives": GameManager.lives})

    if GameManager.lives <= 0:
        set_paused(true, LOSE_MESSAGE)


func _on_Retry_pressed() -> void:
    GameManager.retry()
    scene_tree.paused = false


func _on_Continue_pressed() -> void:
    set_paused(false)


func _on_Quit_pressed() -> void:
    scene_tree.quit()
