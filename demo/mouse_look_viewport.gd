extends ViewportContainer


var angle := Vector3(0.0, 0.0, 0.0)
var distance := 0.4
var _looking := false
var _mouse_over := false

onready var camera := $Viewport/Scene/Camera

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _input(event):
	var update := false

	# Handle button events
	var button := event as InputEventMouseButton
	if button:
		# Handle left-button-drag capture and release
		if button.button_index == BUTTON_LEFT:
			if button.is_pressed() and _mouse_over:
				_looking = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				_looking = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		# Handle zoom-in
		if button.button_index == BUTTON_WHEEL_UP:
			distance = max(distance - 0.01, 0.2)
			update = true

		# Handle zoom-out
		if button.button_index == BUTTON_WHEEL_DOWN:
			distance = min(distance + 0.01, 1.0)
			update = true

	# Handle mouse-motion while looking
	var motion := event as InputEventMouseMotion
	if motion and _looking:
		var vector := motion.relative
		angle.y -= vector.x * 0.01
		angle.x -= vector.y * 0.01
		update = true

	# Handle moving camera if updated
	if update:
		var basis = Basis(angle)
		camera.global_transform.origin = basis.xform(Vector3(0, 0, distance))
		camera.global_transform.basis = basis


func _on_mouse_entered():
	_mouse_over = true


func _on_mouse_exited():
	_mouse_over = false
