extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GroundMap = $GroundMap
onready var RoadMap = $RoadMap
var _AStar = load("_AStar.gd")
var _Node = load("_Node.gd")
var dragging = false
var leftButtonPressed = false
var startNode:_Node
var endNode:_Node
var path:Array
var groundMapArray:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	GroundMap.get_canvas_item()
	for tileList in GroundMap.get_used_cells():
		groundMapArray.push_back(_Node.new(tileList.x, tileList.y, GroundMap.get_cellv(tileList)))
	pass

func _input(event):
	var pos = get_global_mouse_position()
	
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
			var tile = GroundMap.world_to_map(pos)
			GroundMap.set_cellv(tile, -1)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var tile = GroundMap.world_to_map(pos)
		startNode = _Node.new(tile.x, tile.y, GroundMap.get_cellv(tile))
		if not dragging and event.pressed:
			leftButtonPressed = true
			dragging = true
		if dragging and not event.pressed:
			leftButtonPressed = false
			dragging = false
			path.clear()
	elif event is InputEventMouseMotion and leftButtonPressed:
		if dragging:
			clearTempPath()
		var tile = GroundMap.world_to_map(pos)
		endNode = _Node.new(tile.x, tile.y, GroundMap.get_cellv(tile))
		pathFinding_AStar()
		drawPath()
func drawPath():
	for a in path:
		print(a.x, a.y)
		RoadMap.set_cell(a.x, a.y, 2)
func clearTempPath():
	for a in path:
		RoadMap.set_cell(a.x, a.y, -1)

func pathFinding_AStar():
	var groundMap:Array
#	startNode = _Node.new(0, 0)
#	endNode = _Node.new(6, 7)
	var newEndNode
	var newStartNode
	if startNode.x > endNode.x:
		newEndNode = _Node.new(startNode.x, endNode.y)
		newStartNode = _Node.new(endNode.x, startNode.y)
	else:
		newEndNode = endNode
		newStartNode = startNode
	var astar = _AStar.new(startNode, endNode, groundMapArray)
	path = astar.aStar()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
