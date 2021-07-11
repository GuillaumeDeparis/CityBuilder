extends Node2D

signal updateMousePosition

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GroundMap = $GroundMap
onready var RoadMap = $RoadMap
onready var OrgMap = $OrgMap

var dragging = false


var startTile: Vector2
var endTile: Vector2
var arrayRoad = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var tile_back = null
var tile_selected: int = 0


var distance = []
var mapHeight = 10
var mapWidth = 10
const TILE_WALL = 16

const West = {"x": 0, "y": 1}
const North = {"x": -1, "y": 0}
const South = {"x": 1, "y": 0}
const East = {"x": 0, "y": -1}
const Southwest = {"x": 1, "y": 1}
const Southeast = {"x": 1, "y": -1}
const Northwest = {"x": -1, "y": 1}
const Noarteast = {"x": -1, "y": -1}

func _input(event):
	var pos = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
			var tile = GroundMap.world_to_map(pos)
			GroundMap.set_cellv(tile, -1)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
		if dragging and not event.pressed:
			dragging = false
	elif event is InputEventMouseMotion:
		var current_tile = RoadMap.world_to_map(pos)
		RoadMap.set_cellv(current_tile, tile_selected)
		if tile_back == null:
			tile_back = current_tile
		if tile_back != current_tile:
			RoadMap.set_cell(tile_back.x, tile_back.y, -1)
			tile_back = current_tile
	elif event is InputEventMouseMotion and dragging:
#		clearPath()
		if !arrayRoad.has(GroundMap.world_to_map(pos)):
			endTile = GroundMap.world_to_map(pos)
#		construct_road(GroundMap.world_to_map(pos))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Control_updateButton(asset):
	if asset == "house":
		tile_selected = 1
	elif asset == "road":
		tile_selected = 2
	print(asset)
	

