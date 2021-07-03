extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var clicked_cell = world_to_map(event.position)
			print("Je passse ici : ", clicked_cell)
			set_cellv(clicked_cell, 5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
