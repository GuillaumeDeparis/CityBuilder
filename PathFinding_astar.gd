extends Node2D

func getRectTile(startTile, endTile):
	var listTile = []
	for tilex in endTile.x - startTile.x:
		for tiley in endTile.y - startTile.y:
			listTile.push_back({"x": tilex, "y": tiley})
	return listTile
	
#func getUnvisitedNeighbors(tile, queue):
#	var unvisitedNeighbors = []
#	var neighbors = [{"x": 0, "y": 1}, {"x": 1, "y": 0}, {"x": 0, "y": -1}, {"x": -1, "y": 0}]
#	for t in neighbors:
#		var currentNeighbor = tile + t
#		present = queue.has(currentNeighbor)
#		if !present.discovered:
#			unvisitedNeighbors.insert(present)
#	return unvisitedNeighbors

func astar(startPos, endPos):
	var rectTile = getRectTile(startPos, endPos)
	var queue = []
	

	for tile in rectTile:
		tile.distance = 1000
		tile.rootDistance = 1000
		tile.manhattanD =  2 * abs(endPos.x - startPos.x) + abs(endPos.y - startPos.y)
		
	startPos.rootDistance = 0
	queue.insert(0, startPos)
	while !queue.empty():
		var curTile = queue.pop_front()
		curTile.discovered = true
		for neighbor in curTile.getUnvisitedNeighbors():
			neighbor.rDistance = min(neighbor.rootDistance, curTile.rootDistance +1)
			var minDistance = min(neighbor.distance, curTile.rootDistance + neighbor.manhattanD)
			if minDistance != neighbor.distance:
				neighbor.distance = minDistance
				neighbor.parent = curTile
				
				if queue.has(neighbor):
					queue.setPriority(neighbor, minDistance)
			if !queue.has(neighbor):
				queue.insert(neighbor.distance, neighbor)
