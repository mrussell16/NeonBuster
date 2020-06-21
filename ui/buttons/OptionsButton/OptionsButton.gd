extends TextureButton


func _on_pressed() -> void:
    get_tree().change_scene("res://ui/OptionsMenu.tscn")
