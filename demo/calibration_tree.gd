extends Tree


# Button IDs
const BUTTON_ADD := 1
const BUTTON_RECORD := 2
const BUTTON_DELETE := 3


# Phoneme descriptions
const phoneme_descriptions = {
	LipSyncTraining.PHONEME.PHONEME_TS: "Phoneme [tS] (CHeck, CHoose)",
	LipSyncTraining.PHONEME.PHONEME_DZ: "Phoneme [dZ] (Job, aGe)",
	LipSyncTraining.PHONEME.PHONEME_SH: "Phoneme [S] (Job, aGe)",
	LipSyncTraining.PHONEME.PHONEME_T: "Phoneme [t] (Take, haT)",
	LipSyncTraining.PHONEME.PHONEME_D: "Phoneme [d] (Day, haD)",
	LipSyncTraining.PHONEME.PHONEME_E: "Phoneme [e] (Ever, bEd)",
}


# Icons for buttons
onready var delete_icon = load("res://assets/open_iconic/delete.png")
onready var microphone_icon = load("res://assets/open_iconic/microphone.png")
onready var plus_icon = load("res://assets/open_iconic/plus.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the file data changed event
	LipSyncGlobals.connect("file_data_changed", self, "_on_file_data_changed")
	
	# Connect the button-pressed event
	connect("button_pressed", self, "_on_button_pressed")
	connect("item_edited", self, "_on_item_edited")

	# Configure the columns
	set_column_expand(0, true)
	set_column_expand(1, false)
	set_column_min_width(1, 60)

	# Populate the tree
	_populate_tree()


## Handle button presses
func _on_button_pressed(item: TreeItem, _column: int, id: int):
	match id:
		BUTTON_ADD:
			_on_add_fingerprint(item)
		
		BUTTON_RECORD:
			_on_record_fingerprint(item)
			
		BUTTON_DELETE:
			_on_delete_fingerprint(item)


## Handle item edited
func _on_item_edited():
	_on_fingerprint_edited(get_edited())


## Handle add button pressed on phoneme node
func _on_add_fingerprint(phoneme_node: TreeItem):
	# Get the phoneme
	var phoneme: int = phoneme_node.get_metadata(0)

	# TODO: Construct the fingerprint
	var fingerprint := LipSyncFingerprint.new()
	fingerprint.description = "unnamed"

	# If necessary, construct phoneme entry in training data
	if not phoneme in LipSyncGlobals.file_data.training:
		LipSyncGlobals.file_data.training[phoneme] = []

	# Add fingerprint to training data
	LipSyncGlobals.file_data.training[phoneme].push_back(fingerprint)

	# Create the new node
	var fingerprint_node = create_item(phoneme_node)
	fingerprint_node.set_text(0, fingerprint.description)
	fingerprint_node.add_button(1, microphone_icon, BUTTON_RECORD)
	fingerprint_node.add_button(1, delete_icon, BUTTON_DELETE)
	fingerprint_node.set_editable(0, true)
	fingerprint_node.set_metadata(0, phoneme)
	fingerprint_node.set_metadata(1, fingerprint)

	# Report modified by tree manipulation
	LipSyncGlobals.set_modified("tree")


## Handle record button pressed on fingerprint node
func _on_record_fingerprint(fingerprint_node: TreeItem):
	# Get the phoneme and fingerprint
	var phoneme: int = fingerprint_node.get_metadata(0)
	var fingerprint: LipSyncFingerprint = fingerprint_node.get_metadata(1)

	# Report modified by tree manipulation
	LipSyncGlobals.set_modified("tree")


## Handle delete button pressed on fingerprint node
func _on_delete_fingerprint(fingerprint_node: TreeItem):
	# Get the phoneme and fingerprint
	var phoneme: int = fingerprint_node.get_metadata(0)
	var fingerprint: LipSyncFingerprint = fingerprint_node.get_metadata(1)

	# Get the array of fingerprints in the training data
	var fingerprints: Array = LipSyncGlobals.file_data.training[phoneme]

	# Erase the fingerprint (and possibly the entire phoneme)
	fingerprints.erase(fingerprint)
	if fingerprints.size() == 0:
		LipSyncGlobals.file_data.training.erase(phoneme)

	# Delete the node
	fingerprint_node.free()

	# Report modified by tree manipulation
	LipSyncGlobals.set_modified("tree")


func _on_fingerprint_edited(fingerprint_node: TreeItem):
	# Get the fingerprint
	var fingerprint: LipSyncFingerprint = fingerprint_node.get_metadata(1)

	# Get the description
	var description = fingerprint_node.get_text(0)
	if description == "":
		# Fix empty descriptions
		description = "unnamed"
		fingerprint_node.set_text(0, description)

	# Save the description
	fingerprint.description = description

	# Report modified by tree manipulation
	LipSyncGlobals.set_modified("tree")


## Handle changes to the file data
func _on_file_data_changed(cause):
	# Skip if we caused the change
	if cause == "tree":
		return

	# Update the tree to show the change
	_populate_tree()


## Populate the tree
func _populate_tree():
	# Clear the tree
	clear()

	# Create the root item
	var root = create_item()

	# Iterate over all possible phonemes
	for phoneme in LipSyncTraining.PHONEME.COUNT:
		# Skip unknown phonemes
		if not phoneme in phoneme_descriptions:
			continue

		# Construct the phoneme node
		var phoneme_node = create_item(root, phoneme)
		phoneme_node.set_text(0, phoneme_descriptions[phoneme])
		phoneme_node.add_button(1, plus_icon, BUTTON_ADD)
		phoneme_node.set_selectable(0, false)
		phoneme_node.set_metadata(0, phoneme)

		# Skip if no fingerprints in training data
		if not phoneme in LipSyncGlobals.file_data.training:
			continue

		# Add all fingerprints
		for fingerprint in LipSyncGlobals.file_data.training[phoneme]:
			var fingerprint_node = create_item(phoneme_node)
			fingerprint_node.set_text(0, fingerprint.description)
			fingerprint_node.add_button(1, microphone_icon, BUTTON_RECORD)
			fingerprint_node.add_button(1, delete_icon, BUTTON_DELETE)
			fingerprint_node.set_editable(0, true)
			fingerprint_node.set_metadata(0, phoneme)
			fingerprint_node.set_metadata(1, fingerprint)
