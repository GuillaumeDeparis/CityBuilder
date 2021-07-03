extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Noeud:
	var x: int 
	var y: int
	var cout: int
	var heuristique: int
	
	func _init(_x, _y, _cout, _heurisitique):
		x = _x
		y = _y
		cout = _cout
		heuristique = _heurisitique

var voisins = [{"x": 0, "y": 1},{"x": 0, "y": -1},{"x": 1, "y": 0},{"x": -1, "y": 0}]
onready var GroundMap = $GroundMap
onready var BuildMap = $BuildMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var depart = Noeud.new(0, -4, 0, 0)
	var objectif = Noeud.new(2, -4, 0, 0)
	cheminPlusCourt(objectif, depart)
	pass # Replace with function body.


func compare2Noeuds(n1:Noeud, n2:Noeud):
	if n1.heuristique < n2.heuristique:
		return 1
	elif n1.heuristique == n2.heuristique:
		return 0
	else:
		return -1

func manhattanDistance(n1:Noeud, n2:Noeud):
	return abs(n2.x - n1.x) + abs(n2.y - n1.y)

func cheminPlusCourt(objectif:Noeud, depart:Noeud):
	var closedList = []
	var openList = []
	openList.insert(depart)
	while not openList.empty():
		var u = openList.pop_front()
		for v in voisins:
			var currentVoisin = Noeud.new(u.x + v.x, u.y + v.y, 0, 0)
			var g = manhattanDistance(u, currentVoisin)
#			var f = u.
			if not closedList.find(currentVoisin) || openList.find(v.cout):
				v.cout = u.cout+1
				v.heuristique = v.cout + distance([v.x, v.y], [objectif.x, objectif.y])
		closedList.push_back(u)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
