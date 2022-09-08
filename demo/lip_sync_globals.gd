extends Node


## Signal emitted when the file state changes
signal file_changed


## Training file name
var file_name := ""

## Training file modified
var file_modified := false

## Training file data
var file_data := LipSyncTraining.new()


func new_file():
	# Clear the data
	file_name = ""
	file_data = LipSyncTraining.new()
	file_modified = false

	# Report file changed
	emit_signal("file_changed")


func load_file(path: String):
	# Load the data
	file_name = path
	file_data = ResourceLoader.load(path)
	file_modified = false

	# Report file changed
	emit_signal("file_changed")


func save_file():
	# Save the resource
	ResourceSaver.save(file_name, file_data)
	file_modified = false

	# Report file changed
	emit_signal("file_changed")


func save_file_as(path: String):
	# Set the file name and save
	file_name = path
	save_file()


func file_display_name() -> String:
		# Pick a display name
	var display_name := "unnamed" if file_name == "" else file_name

	# Add modified flag
	if file_modified:
		display_name = "*" + display_name

	# Return the display name
	return display_name
