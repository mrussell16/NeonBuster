extends Control


onready var play_button: Node = $Menu/PlayButton


func _ready() -> void:
    play_button.grab_focus()
