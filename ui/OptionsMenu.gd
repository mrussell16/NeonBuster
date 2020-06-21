extends Control


onready var sample_sfx: AudioStreamPlayer = $Menu/EffectsVolume/SampleSFX
onready var master_slider: Slider = $Menu/MasterVolume/Slider
onready var music_slider: Slider = $Menu/MusicVolume/Slider
onready var effects_slider: Slider = $Menu/EffectsVolume/Slider


func _ready() -> void:
    master_slider.grab_focus()
    master_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
    music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
    effects_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects"))


func _on_MasterVolume_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_MusicVolume_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_EffectsVolume_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)
    sample_sfx.play()
