extends Control
signal console_open(isOpen)

var console_in_use = false

func _input(event):
	if event is InputEventKey and event.pressed and not console_in_use:
		if event.keycode == KEY_ESCAPE:
			console_open.emit("opened")
			show()
			console_in_use = true
	elif event is InputEventKey and event.pressed and console_in_use:
		if event.keycode == KEY_ESCAPE:
			console_open.emit("closed")
			hide()
			console_in_use = false
	if event is InputEventKey and event.pressed and console_in_use:
		if event.keycode == KEY_ENTER:
			console_open.emit($LineEdit.text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
