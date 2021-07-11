class_name _AStar

var _Node = load("_Node.gd")
var groundArray = []
var openArray = []
var closeArray = []
var startPoint = Vector2(10,10)
var endPoint = Vector2(0,0)
var startNode:_Node
var endNode:_Node
const obs = 14

#var nList = { Vector2(-1, -1):"NW", Vector2(0, -1): "N",  Vector2(1, -1):"NE", Vector2(1,0):"E",
#			Vector2(1,1):"SE", Vector2(0,1):"S",  Vector2(-1,1):"SW", Vector2(-1,0):"W" }
var nList = { Vector2(0, -1): "N", Vector2(1,0):"E",
			Vector2(0,1):"S", Vector2(-1,0):"W" }

func _init(_startNode:_Node, _endNode:_Node, _groundArray:Array):
	self.startNode = _startNode
	self.endNode = _endNode
	self.groundArray = _groundArray

func getDistanceByMannathan(pointA:_Node, pointB:_Node):
	return abs(pointB.x - pointA.x) + abs(pointB.y - pointA.y)

func searchInArray(array:Array, node: _Node):
	for a in array:
		if a.x == node.x && a.y == node.y:
			return a
	return null

# Trie la liste ouvert par distance
# Récupère le meilleur chemin de la liste ouverte
# L'ajoute dans la liste fermée.
# Retourne le meilleur chemin
func addToCloseList():
	openArray.sort_custom(_Node, "sortByDistance")
	var currentNode = openArray.pop_front()
	closeArray.push_back(currentNode)
	return currentNode

func checkAllNeighbor(node: _Node):
	for n in nList:
		var currentNeighbor = _Node.new(node.x + n.x, node.y + n.y)
#		var currentIndexGroundMap = GroundMap.get_cell(currentNeighbor.x, currentNeighbor.y)
#		if  currentIndexGroundMap != obs && currentIndexGroundMap != -1: #Le voisin n'est pas un obstacle
		var currentGroundArray = searchInArray(groundArray, currentNeighbor)
		if  currentGroundArray != null && currentGroundArray.tileIndex != obs && currentGroundArray.tileIndex != -1: #Le voisin n'est pas un obstacle
			var currentNeighborInCloseArray = searchInArray(closeArray, currentNeighbor)
			if currentNeighborInCloseArray == null: #Le voisin ne se trouve pas dans la liste fermée
				currentNeighbor.cout_g = node.cout_g + getDistanceByMannathan(currentNeighbor, node)
				currentNeighbor.cout_h = getDistanceByMannathan(currentNeighbor, endNode)
				currentNeighbor.cout_f = currentNeighbor.cout_g + currentNeighbor.cout_h
				currentNeighbor.parent = node
				var currentNeighborInOpenArray = searchInArray(openArray,currentNeighbor)
				if currentNeighborInOpenArray != null: #Le voisin se trouve dans la liste ouverte
					if currentNeighbor.cout_f <  currentNeighborInOpenArray.cout_f:
						currentNeighborInOpenArray = currentNeighbor
				else: #Le voisin n'existe pas dans la liste ouverte et fermée
					openArray.push_front(currentNeighbor)

func getPath():
	var finalPath  = []
	finalPath.push_back(startNode)
	var currentNode = searchInArray(closeArray, endNode)
	if currentNode != null:
		var atStartNode = false
		while !atStartNode:
			finalPath.push_back(currentNode)
			if currentNode.parent == null:
				atStartNode = true
			else:	
				currentNode = searchInArray(closeArray, currentNode.parent)
	return finalPath

func aStar():
#	endNode = _Node.new(endPoint.x, endPoint.y)
#	startNode = _Node.new(startPoint.x, startPoint.y) #initialisation du premier point
	openArray.push_back(startNode)
	while !openArray.empty():
		var currentNode = addToCloseList()
		checkAllNeighbor(currentNode)
	return getPath()
