var/construction_kits_initialized = 0

proc/init_construction_kits()
	if(construction_kits_initialized)
		return 0
	construction_kits_initialized = 1
	world << "\red \b Initializing Construction Kits"

	//Add construction kits below.
//	add_construction_kit("Test",/obj/item/weapon/crowbar,3)
	add_construction_kit("Autolathe",/obj/machinery/autolathe,5)
	add_construction_kit("Security Camera",/obj/machinery/camera,3)
	add_construction_kit("Tank Dispenser",/obj/machinery/dispenser,9)
	add_construction_kit("DNA Scanner",/obj/machinery/dna_scannernew,6)
	add_construction_kit("Mass Driver",/obj/machinery/mass_driver,4)
	add_construction_kit("DNA Modifier Access Console",/obj/machinery/scan_consolenew,6)
	add_construction_kit("Teleporter Hub",/obj/machinery/teleport/hub,11)
	add_construction_kit("Teleporter Station",/obj/machinery/teleport/station,11)
	add_construction_kit("Solar panel",/obj/machinery/power/solar,6)
	add_construction_kit("Coffee Machine",/obj/machinery/vending/coffee,4)
	add_construction_kit("Chemistry Vendor",/obj/machinery/vending/chemi,15)
	add_construction_kit("Mining Vendor",/obj/machinery/vending/mining,15)
	add_construction_kit("Snack Machine",/obj/machinery/vending/snack,5)
	add_construction_kit("Cigarette Machine",/obj/machinery/vending/cigarette,4)
	add_construction_kit("Medical Vendor",/obj/machinery/vending/medical,15)
	add_construction_kit("Microwave",/obj/machinery/microwave,4)





	//End add construction kits.