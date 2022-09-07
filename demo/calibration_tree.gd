extends Tree


# Button IDs
const BUTTON_ADD := 1
const BUTTON_RECORD := 2
const BUTTON_DELETE := 3


# Icons for buttons
onready var delete_icon = load("res://assets/open_iconic/delete.png")
onready var microphone_icon = load("res://assets/open_iconic/microphone.png")
onready var plus_icon = load("res://assets/open_iconic/plus.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button-pressed event
	connect("button_pressed", self, "_on_button_pressed")

	# Configure the columns
	set_column_expand(0, true)
	set_column_expand(1, false)
	set_column_min_width(1, 60)
	
	var root = create_item()
	var viseme_ch = create_item(root)
	viseme_ch.set_text(0, "Viseme CH")
	viseme_ch.collapsed = true
	viseme_ch.set_selectable(0, false)
	
	var phoneme_ts = create_item(viseme_ch)
	phoneme_ts.set_text(0, "/tS/ (CHeck, CHoose)")
	phoneme_ts.add_button(1, plus_icon, BUTTON_ADD)
	phoneme_ts.collapsed = true
	phoneme_ts.set_selectable(0, false)
	
	var phoneme_ts_recording = create_item(phoneme_ts)
	phoneme_ts_recording.set_text(0, "Sample")
	phoneme_ts_recording.add_button(1, microphone_icon, BUTTON_RECORD)
	phoneme_ts_recording.add_button(1, delete_icon, BUTTON_DELETE)
	phoneme_ts_recording.set_selectable(0, false)
	
	var phoneme_dz = create_item(viseme_ch)
	phoneme_dz.set_text(0, "/dZ/ (Job, aGe)")
	phoneme_dz.add_button(1, plus_icon, BUTTON_ADD)
	phoneme_dz.collapsed = true
	phoneme_dz.set_selectable(0, false)
	
	var phoneme_dz_recording = create_item(phoneme_dz)
	phoneme_dz_recording.set_text(0, "Sample")
	phoneme_dz_recording.add_button(1, microphone_icon, BUTTON_RECORD)
	phoneme_dz_recording.add_button(1, delete_icon, BUTTON_DELETE)
	phoneme_dz_recording.set_selectable(0, false)


func _on_button_pressed(item: TreeItem, _column: int, id: int):
	pass
