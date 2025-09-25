extends StaticBody3D

var scan_data: Dictionary = {
	"label" : "an item",
	"entry" : "stuff about the item that it is completely mind blowing",
	"scan_time" : 2
}

func get_scan_data() -> Dictionary:
	return scan_data
