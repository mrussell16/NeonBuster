tool
extends Control


export(String, FILE) var first_level: = ""


onready var scene_tree := get_tree()


func _on_Play_pressed() -> void:
    scene_tree.paused = false
    GameManager.reset()
    scene_tree.change_scene(first_level)


func _on_Quit_pressed() -> void:
    scene_tree.quit()


func _get_configuration_warning() -> String:
    return "First Level must be set" if first_level == "" else ""
