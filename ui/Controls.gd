extends Control


onready var main_menu_button: Node = $Menu/MainMenuButton


func _ready() -> void:
    main_menu_button.grab_focus()
