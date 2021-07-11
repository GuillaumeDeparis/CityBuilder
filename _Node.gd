class_name _Node
extends Node

var x: int
var y: int
var cout_g: int # cout du point de départ au noeud considéré
var cout_h: int # cout du noeud considéré au noeud de destination
var cout_f: int # somme des précédents, mais mémorisé pour ne pas le recalculer à chaque fois.
var parent
var tileIndex
var tileName


func _init(_x:int, _y:int, _tileIndex:int=0, _tileName:String="", _cout_g:int=0, _cout_h:int=0, _cout_f:int=0):
	self.x = _x
	self.y = _y
	self.tileIndex = _tileIndex
	self.tileName = _tileName
	self.cout_g = _cout_g
	self.cout_h = _cout_h
	self.cout_f = _cout_f
	self.parent = null

static func sortByDistance(a, b):
	if a.cout_f < b.cout_f:
		return true
	return false
