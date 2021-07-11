extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal updateButton

onready var roadButton = $build/GridContainer/Road
onready var HouseButton = $build/GridContainer/House

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_House_pressed():
	#Selection de la maison
	print("House Selection")
	emit_signal("updateButton", "house")


func _on_Road_pressed():
	print("Road selection")
	emit_signal("updateButton", "road")
