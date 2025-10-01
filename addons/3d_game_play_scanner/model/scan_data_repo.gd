extends Node

var scan_data_entries: ScanDataLinkedList = ScanDataLinkedList.new() #refactor to be an array

func add_scan_data_entry(scan_data) -> void:
	var scan_data_entry = ScanDataLinkedList.new()
	scan_data_entry.data = scan_data
	scan_data_entries= scan_data_entries.append(scan_data_entries, scan_data_entry)

func get_all_scan_entries() -> Array:
	var scan_entries: Array
	var entry = scan_data_entries
	
	while not entry == null:
		scan_entries.append(entry.data)
		entry = entry.next
	
	return scan_entries

func get_scan_entry(index: int):
	var entry = scan_data_entries.get_by_index(scan_data_entries, index)
	return entry

func on_scanned(data) -> void:
	var new_entry = ScanDataLinkedList.new()
	
	new_entry.data = data
	scan_data_entries = scan_data_entries.append(scan_data_entries, new_entry)
