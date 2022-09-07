extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect main menu signals
	$MainMenuBar.connect("menu_file_new", self, "_on_file_new")
	$MainMenuBar.connect("menu_file_open", self, "_on_file_open")
	$MainMenuBar.connect("menu_file_save", self, "_on_file_save")
	$MainMenuBar.connect("menu_file_exit", self, "_on_file_exit")
	$MainMenuBar.connect("menu_audio_microphone", self, "_on_audio_microphone")
	$MainMenuBar.connect("menu_audio_microphone_loop", self, "_on_audio_microphone_loop")
	$MainMenuBar.connect("menu_audio_play_resource", self, "_on_audio_play_resource")
	$MainMenuBar.connect("menu_audio_play_file", self, "_on_audio_play_file")
	$MainMenuBar.connect("menu_help_about", self, "_on_help_about")

func _on_file_exit():
	get_tree().quit()

func _on_audio_microphone():
	$AudioStreamPlayer.play_microphone()

func _on_audio_microphone_loop():
	$AudioStreamPlayer.play_microphone_loop()

func _on_audio_play_resource(name: String):
	$AudioStreamPlayer.play_resource(name)

func _on_help_about():
	$AboutDialog.popup()

func _on_audio_play_file():
	$AudioFileDialog.popup()

func _on_AudioFileDialog_file_selected(path):
	$AudioStreamPlayer.play_file(path)
