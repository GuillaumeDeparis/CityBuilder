extends Node

class PathFinding_Node:
	var x
	var y
	var f
	var g
	var h
	var opened
	var closed
	var parent
	var walkable
	
	func _init(_x, _y, _walkable):
		x = _x
		y = _y
		f = 0
		g = 0
		h = 0
		opened = false
		closed = false
		walkable = _walkable
