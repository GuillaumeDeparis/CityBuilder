extends Node2D
#https://members.loria.fr/VThomas/mediation/ISN_2019_labyrinthe/
#https://bitbucket.org/dalerank/caesaria
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class MemPos:
	var Wave :int
	var Tile: Vector2


var height = 25
var width = 25
onready var GroundMap = $GroundMap
onready var BuildMap = $BuildMap



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
var dragging = false
var startTile
var endTile
func _input(event):
#	if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
	var pos = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
			var tile = GroundMap.world_to_map(pos)
			GroundMap.set_cellv(tile, -1)		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true	
			startTile = GroundMap.world_to_map(pos)
		if dragging and not event.pressed:
			dragging = false
			endTile = GroundMap.world_to_map(pos)
			constructRoad(startTile, endTile)
			
var array = []
func constructRoad(sTile, eTile):
	var wave = 0 #Initialisation de la premiere vague
	array.insert(wave, [{"x":sTile.x, "y":sTile.y}])
#	array.push_back({"x":startTile.x, "y":startTile.y, "wave": wave})
	print("start tile: ", sTile)
	print("end tile: ", eTile)
	var finishTile = {"x":eTile.x, "y":eTile.y}
#	array.insert(wave, [currentTile])
#	array[wave].push_back(endTile)
	var isContinue = true
	while isContinue:
			isContinue = check_neighbor(wave, finishTile)
			if !isContinue:
				break
			else:
				wave = wave +1
	var newArray = []
	for indexArray in range(array.size()-1, -1, -1):
		for tile in array[indexArray]:
			newArray.push_back({"x": tile.x, "y":tile.y, "wave": indexArray})
			BuildMap.set_cell(tile.x, tile.y, indexArray)
#	draw_path(endTile, newArray, wave)
	newArray.clear()
	

func check_OutOfMap(tilePosition):
	if tilePosition.x > width:
		return true
	elif tilePosition.y > height:
		return true
	else:
		return false

func searchInArray(b):
	for listTile in array:
		for tile in listTile:
			if tile.x == b.x && tile.y == b.y:
				return true

func getWaveFromNewArray(listTile, wave, b):
	for tile in listTile:
		if tile.x == b.x && tile.y == b.y && tile.wave == wave:
			return true

func check_neighbor(wave, finishTile):
	var nextWave = wave + 1
	var tmpCurrentArray = []
	for currentTile in array[wave]:
		tmpCurrentArray.clear()
		var listNeighbor = [{"x":1, "y":0}, {"x":-1, "y":0}, {"x":0, "y":1}, {"x":0, "y":-1}]
		for n in listNeighbor:
			var neighbor ={"x":currentTile.x+n.x, "y":currentTile.y+n.y}
			if !searchInArray(neighbor):
				tmpCurrentArray.push_back(neighbor)	
		if array.size() == nextWave:
			array.insert(nextWave, tmpCurrentArray.duplicate(true))
		else:
			array[nextWave].append_array(tmpCurrentArray.duplicate(true))
		for n in listNeighbor:
			var neighbor ={"x":currentTile.x+n.x, "y":currentTile.y+n.y}
			if neighbor.x == finishTile.x && neighbor.y == finishTile.y:
				return false
	return true

func draw_path(tile, newArray, maxWave):
	var maxVal = 1000
	var tilex = tile.x
	var tiley = tile.y 
	var path = []
	path = [{"x": tilex, "y": tiley}]
	var listNeighbor = [{"x":1, "y":0}, {"x":-1, "y":0}, {"x":0, "y":1}, {"x":0, "y":-1}]
	var minVal = maxVal
	var currentWave = maxWave
	for wave in range(currentWave, -1, -1):
		var neighborMin = {}
		for neighbor in listNeighbor:
			var nx = tilex + neighbor.x
			var ny = tiley + neighbor.y
			var exist = getWaveFromNewArray(newArray, wave, {"x":nx, "y":ny}) # Ajouter un filtre sur la vague courante pour accélérer la recherche
			if exist != null:
				if wave < minVal:
					minVal = wave
					neighborMin = {"x": nx, "y": ny}
					path.append(neighborMin)
					tilex = neighborMin.x
					tiley = neighborMin.y
	#print("Path: ", path)
	for p in path:
		BuildMap.set_cell(p.x, p.y, 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
