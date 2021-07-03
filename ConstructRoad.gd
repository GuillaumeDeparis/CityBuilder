extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GroundMap = $GroundMap
onready var RoadMap = $RoadMap
onready var BuildMap = $BuildMap

const N = 1
const E = 2
const S = 4
const W = 8

var cell_road = {Vector2(0, -1): N, Vector2(1, 0): E, Vector2(0, 1): S, Vector2(-1, 0): W}
var dragging = false
var path = []

var startTile: Vector2
var endTile: Vector2
var arrayRoad = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	var pos = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
			var tile = GroundMap.world_to_map(pos)
			GroundMap.set_cellv(tile, -1)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
#			obtenir la liste de tuile permettant d'accéder de la tuile de départ à la tuile sous la souris.
#			construct_road(GroundMap.world_to_map(pos))
			startTile = GroundMap.world_to_map(pos)
			endTile = GroundMap.world_to_map(pos)
			getPath(startTile, endTile)			
		if dragging and not event.pressed:
			dragging = false
			
	elif event is InputEventMouseMotion and dragging:
#		clearPath()
		if !arrayRoad.has(GroundMap.world_to_map(pos)):
			endTile = GroundMap.world_to_map(pos)
			getPath(startTile, endTile)
#		construct_road(GroundMap.world_to_map(pos))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func clearPath():
	print("arrayRoad: ", arrayRoad)
	for road in arrayRoad:
		RoadMap.set_cellv(road, -1)
	RoadMap.update()

func getPath(startTile, endTile):
#	print("startTile: ", startTile)
#	print("endTile: ", endTile)
	for tilex in endTile.x+1 - startTile.x:
		if !arrayRoad.has(Vector2(tilex, startTile.y)):
			arrayRoad.push_back(Vector2(tilex, startTile.y))
	for tiley in endTile.y+1 - startTile.y:
		if !arrayRoad.has(Vector2(endTile.x, tiley)):
			arrayRoad.push_back(Vector2(endTile.x, tiley))

	for road in arrayRoad:
		RoadMap.set_cellv(road, 11)
		update_neighbor(road)

func check_neighbors(cell):
	var weightList = {}
	for n in cell_road.keys():
		var neighbor = cell + n
		var currentNeighbor_weight = RoadMap.get_cellv(neighbor)
		weightList[cell_road[n]] = currentNeighbor_weight	
	return weightList


#Pas très propre, revoir la gestion des multiples 16
func getRoadDirection(array):
	var dir = 15
	var countNeg1 = 0
	var count = 0
	var count16 = false
	if array.values().find_last(16) >= 1: #Au moin 2 occurrence de 16
		count16 = true
	for a in array.keys():
		if array.get(a) == 16: #récupération du degré de liberté
			count = count + 1
			if count16 && count < 2:
				dir = dir - a
		elif array.get(a) != -1: # on récupère le degré de liberté, cependant la cellule adjacente devra être mise à jour.
			dir = dir - a
		else:
			countNeg1 = countNeg1 + 1
	if countNeg1 == 4:
		dir = 11 # route par défaut.
	return dir
	
func update_neighbor(cell):
	var array = []
	for n in cell_road.keys():
		array.push_back(Vector2(cell.x + n.x, cell.y + n.y))
		for neighbor in array:
			if RoadMap.get_cellv(neighbor) != -1:
				var weight = check_neighbors(neighbor)
				RoadMap.set_cellv(neighbor, getRoadDirection(weight))

func construct_road(tilePost:Vector2):
	var weight = check_neighbors(tilePost)
	RoadMap.set_cellv(tilePost, getRoadDirection(weight))
	update_neighbor(tilePost)
