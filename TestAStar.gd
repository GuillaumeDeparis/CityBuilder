extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GroundMap = $GroundMap
onready var RoadMap = $RoadMap
var _AStar = load("_AStar.gd")
var _Node = load("_Node.gd")
var dragging = false
var startNode:_Node
var endNode:_Node
var path:Array

# Called when the node enters the scene tree for the first time.
func _ready():
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
			dragging = true
		if dragging and not event.pressed:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var tile = GroundMap.world_to_map(pos)
		endNode = _Node.new(tile.x, tile.y, GroundMap.get_cellv(tile))
		clearPath()
		pathFinding_AStar()
		drawPath()
func drawPath():
	for a in path:
		print(a.x, a.y)
		RoadMap.set_cell(a.x, a.y, 2)
func clearPath():
	for a in path:
		RoadMap.set_cell(a.x, a.y, -1)

func pathFinding_AStar():
	var groundMap:Array
	var newEndNode = _Node.new(startNode.x, endNode.y)
	var newStartNode = _Node.new(endNode.x, startNode.y)
	endNode = _Node.new(10, 10)
	startNode = _Node.new(0, 0)
#	print("(" , startNode.x,  " - ", startNode.y, "), (", endNode.x, " - ", endNode.y,")")
#	print("(", newStartNode.x,  " - ", newStartNode.y,"), (", newEndNode.x, " - ", newEndNode.y,")")
	for nodeX in (newEndNode.x - newStartNode.x)+1:
		for nodeY in (newEndNode.y - newStartNode.y)+1:
			groundMap.push_back(_Node.new(nodeX+newStartNode.x, nodeY+newStartNode.y, GroundMap.get_cell(nodeX, nodeY)))
#	print("=== Debut ===")
#	for a in groundMap:
#		print(a.x, " - ", a.y)
#	print("=== Fin ===")
	var astar = _AStar.new(startNode, endNode, groundMap)
	path = astar.aStar()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
