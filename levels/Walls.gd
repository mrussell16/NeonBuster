extends StaticBody2D


func _on_Killbox_body_entered(body: Node) -> void:
    if body.has_method("on_killbox_enter"):
        body.on_killbox_enter()
    else:
        body.queue_free()
