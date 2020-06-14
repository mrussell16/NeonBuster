extends Block
class_name Block2


var cracked = false
var cracked_sprite = preload("res://actors/Block/Block2Cracked.png")


func _on_collision() -> void:
    if not cracked:
        sprite.texture = cracked_sprite
        cracked = true
    else:
        _on_destroy()
