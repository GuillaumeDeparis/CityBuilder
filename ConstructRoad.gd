extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GroundMap = $GroundMap
onready var RoadMap = $RoadMap

var dragging = false


var startTile: Vector2
var endTile: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	initMap()
	pass # Replace with function body.


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
			startTile = GroundMap.world_to_map(pos)
			endTile = GroundMap.world_to_map(pos)
			getDistanceStartToEnd(startTile, endTile)
		if dragging and not event.pressed:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		endTile = GroundMap.world_to_map(pos)

var tileList = []
var Neighbor = load("Neighbor.gd")
var _Node = load("PathFinding_node.gd")
func initMap():
	#pour chaque tile, créer une instance de PathFinding_Node
	for tile in GroundMap.get_used_cells():
		tileList.push_back(_Node.new(tile.x, tile.y, true))
		
	
func getDistanceStartToEnd(startPos, endPos):
	distance[startPos.x][startPos.y] = Neighbor.new()
	print(distance[startPos.x][startPos.y][West])
