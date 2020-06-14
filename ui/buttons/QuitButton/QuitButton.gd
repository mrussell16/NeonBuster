extends TextureButton


onready var scene_tree := get_tree()


func _on_pressed() -> void:
    scene_tree.quit()
