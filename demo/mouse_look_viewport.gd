extends ViewportContainer



var angle := Vector3(0.0, 0.0, 0.0)
var distance := 0.4

onready var camera := $Viewport/Scene/Camera


func _input(event):
	var update := false

	var button := event as InputEventMouseButton
	var motion := event as InputEventMouseMotion

	if button and button.is_pressed():
		if button.button_index == BUTTON_WHEEL_UP:
			distance = max(distance - 0.01, 0.2)
			update = true
		if button.button_index == BUTTON_WHEEL_DOWN:
			distance = min(distance + 0.01, 1.0)
			update = true

	if motion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var vector := motion.relative
		angle.y -= vector.x * 0.01
		angle.x -= vector.y * 0.01
		update = true


	if update:
		var basis = Basis(angle)
		camera.global_transform.origin = basis.xform(Vector3(0, 0, distance))
		camera.global_transform.basis = basis
