extends Control

# Menu IDs
const FILE_NEW_ID := 100
const FILE_OPEN_ID := 101
const FILE_SAVE_ID := 102
const FILE_EXIT_ID := 103
const AUDIO_MICROPHONE_ID := 200
const AUDIO_MICROPHONE_LOOP_ID := 201
const AUDIO_PLAY_ALONE := 202
const AUDIO_PLAY_JABBERWOCKY := 203
const AUDIO_PLAY_FILE := 204
const HELP_ABOUT := 300

# Called when the node enters the scene tree for the first time.
func _ready():
	# Populate file menu
	$MenuBar/FileMenu.get_popup().add_item("New", FILE_NEW_ID, KEY_N | KEY_MASK_CTRL)
	$MenuBar/FileMenu.get_popup().add_item("Open", FILE_OPEN_ID, KEY_O | KEY_MASK_CTRL)
	$MenuBar/FileMenu.get_popup().add_item("Save", FILE_SAVE_ID, KEY_S | KEY_MASK_CTRL)
	$MenuBar/FileMenu.get_popup().add_separator()
	$MenuBar/FileMenu.get_popup().add_item("Exit", FILE_EXIT_ID, KEY_F4 | KEY_MASK_ALT)
	$MenuBar/FileMenu.get_popup().connect("id_pressed", self, "_on_menu_id_pressed")

	# Populate audio menu
	$MenuBar/AudioMenu.get_popup().add_item("Microphone", AUDIO_MICROPHONE_ID, KEY_1 | KEY_MASK_CTRL)
	$MenuBar/AudioMenu.get_popup().add_item("Microphone Loop", AUDIO_MICROPHONE_LOOP_ID, KEY_2 | KEY_MASK_CTRL)
	$MenuBar/AudioMenu.get_popup().add_item("Play Alone", AUDIO_PLAY_ALONE, KEY_3 | KEY_MASK_CTRL)
	$MenuBar/AudioMenu.get_popup().add_item("Play Jabberwocky", AUDIO_PLAY_JABBERWOCKY, KEY_4 | KEY_MASK_CTRL)
	$MenuBar/AudioMenu.get_popup().add_item("Play File", AUDIO_PLAY_FILE, KEY_M | KEY_MASK_CTRL)
	$MenuBar/AudioMenu.get_popup().connect("id_pressed", self, "_on_menu_id_pressed")

	# Populate help menu
	$MenuBar/HelpMenu.get_popup().add_item("About", HELP_ABOUT, KEY_F1)
	$MenuBar/HelpMenu.get_popup().connect("id_pressed", self, "_on_menu_id_pressed")

func _on_menu_id_pressed(id: int):
	match id:
		FILE_NEW_ID:
			pass
		
		FILE_OPEN_ID:
			pass
		
		FILE_SAVE_ID:
			pass
			
		FILE_EXIT_ID:
			_on_file_exit()
		
		AUDIO_MICROPHONE_ID:
			$AudioStreamPlayer.play_microphone()
			
		AUDIO_MICROPHONE_LOOP_ID:
			$AudioStreamPlayer.play_microphone_loop()
			
		AUDIO_PLAY_ALONE:
			$AudioStreamPlayer.play_alone()
			
		AUDIO_PLAY_JABBERWOCKY:
			$AudioStreamPlayer.play_jabberwocky()
		
		AUDIO_PLAY_FILE:
			_on_audio_play_file()

		HELP_ABOUT:
			_on_help_about()
			

func _on_file_exit():
	get_tree().quit()

func _on_help_about():
	$AboutDialog.popup()

func _on_audio_play_file():
	$AudioFileDialog.popup()

func _on_AudioFileDialog_file_selected(path):
	$AudioStreamPlayer.play_file(path)
