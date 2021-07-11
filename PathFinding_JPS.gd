extends Node2D

onready var RoadMap = $RoadMap

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

var distance #tableau à 2 dimension ayant une liste d'array

func leftToRigt():
	var m_terrain
	var jumpPoints

	for r in mapHeight:
		var count = -1
		var jumPointLastSeen = false
		for c in mapWidth:
			if m_terrain[r][c] == TILE_WALL:
				count = -1
				jumPointLastSeen = false
				distance[r][c][West] = 0
				continue
			count = count +1
			if jumPointLastSeen:
				distance[r][c][West] = count
			else: #Wall last seen
				distance[r][c][West] = -count
			if jumpPoints[r][c][West]:
				count = 0
				jumPointLastSeen = true

func isWall(row, column):
	if(RoadMap.get_cell(row, column) == TILE_WALL):
		return true
	else:
		return false

func downToUp():
	for r in mapHeight:
		for c in mapWidth:
			if isWall(r, c):
				if r == 0 || c == 0 || isWall(r-1, c) || isWall(r, c-1) || isWall(r-1, c-1):
					distance[r][c][Southwest] = 0
				elif !isWall(r-1, c) && !isWall(r, c-1) && (distance[r-1][c-1][South] > 0 || distance[r-1][c-1][West] > 0):
					distance[r][c][Southwest] = 1
			else:
				var jumpDistance = distance[r-1][c-1][Southwest]
				if jumpDistance > 0:
					distance[r][c][Southwest] = 1 + jumpDistance
				else:
					distance[r][c][Southwest] = -1 + jumpDistance
