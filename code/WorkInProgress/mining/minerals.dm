//Mineral object and containers.
//Mineral datum contains information on the specific mineral, to be moved around at will.
/datum/mining/mineral
	var/name = "Generic Mineral"
	var/amount = 0
	var/quality = 0
	var/rarity = 0

	New(amount,quality)
		..()
		if(!amount) amount = rand(1,30)
		if(!quality) quality = rand(1,155) //255 is max quality.
		setAmount(amount)
		setQuality(quality)

	//Accessor functions so we can edit how this works later
	proc/getName()
		return name

	proc/setName(name)
		name = name

	proc/getAmount()
		return amount

	proc/setAmount(newAmount)
		amount = newAmount

	proc/addAmount(addAmount)
		amount += addAmount

	proc/getQuality()
		return quality

	proc/setQuality(newQuality)
		quality = newQuality

	proc/getRarity()
		return rarity

	//Subtypes, implement specific minerals here.
	rock
		name = "Rock"
		rarity = 35

	iron
		name = "Iron"
		rarity = 4

	plasma
		name = "Plasma"
		rarity = 2

	aluminium
		name = "Aluminium"
		rarity = 3

	platinum
		name = "Platinum"
		rarity = 2

	gold
		name = "Gold"
		rarity = 3

	dasal
		name = "Dasal"
		rarity = 1

/turf/surface //Support for 1 mineral currently.
	var/datum/mining/mineral/mineral

	proc/getMinerals()
		return mineral

	proc/setMinerals(newMineral)
		mineral = newMineral
		return 1


/obj/item/weapon/chunk
	name = "chunk"
	icon = 'mining.dmi'
	icon_state = "chunk"
	desc = "A chunk of mineral rich dirt."
	throwforce = 14.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	var/datum/mining/mineral/list/minerals = list()

	New()
		..()
		pixel_x = pixel_x + rand(-5,5)
		pixel_y = pixel_y + rand(-5,5)

	proc/getMinerals()
		return minerals

	proc/getMineralByName(name as text)
		for(var/datum/mining/mineral/M in minerals)
			if(M.getName() == name)
				return M
		return 0

	proc/addMineral(datum/mining/mineral/M)
		for(var/datum/mining/mineral/check in minerals)
			if(check.getName() == M.getName() && check.getQuality() == M.getQuality())
				check.addAmount(M.getAmount())
				return 1
		minerals += M
		return 1

	proc/removeMineralByName(name as text)
		for(var/datum/mining/mineral/M in minerals)
			if(M.getName() == name)
				del M
				return 1
		return 0

//----------------------------------------------------------------------------------------------------------
//Procs for managing mineral generation, removal, etc.

var/list/mineral_rarity_table = list()

proc/generate_mineral_rarity_table() //Translate the rarity table into something we can use.
	var/totalRarity = 0
	for(var/type in (typesof(/datum/mining/mineral)-/datum/mining/mineral)) //First build the table and decide how much rarity we have overall.
		var/datum/mining/mineral/temp = new type()
		mineral_rarity_table[type] = temp.getRarity()
		totalRarity += temp.getRarity()

	var/subtotal = 0
	for(var/type in mineral_rarity_table) //Iterate through the table, converting them into %s.
		var/mineralPercentage = round((mineral_rarity_table[type]/totalRarity)*100) //Convert it to a %.
		subtotal += mineralPercentage
		mineral_rarity_table[type] = subtotal
	return 1 //We now have a mineral rarity table with the % coverage of each! HUZZAH!

proc/generateMineralDeposit(x,y,z,size,density,quality,mineral)
	if(!x || !y || !z) return 0
	if(!size)
		size = rand(10)
	if(!density)
		density = rand(30) //How many ore per tile.
	if(!quality)
		quality = rand(1,155) //255 is max.
	if(!mineral)
		var/choice = rand(1,100)
		var/highest = 0
		var/highestType = null

	size = (size%2)? size : size+1 //Only adding support for odd widths for now. Could add more complex shapes later.(Procedural map generation style?)
	var/usefulSize = (size-1)/2 //Much more helpful for calculating things. The distance between the point furthest from x and x.

	for(var/activeX = x-usefulSize; activeX <= x+usefulSize; activeX++)
		var/height = size - abs(x-activeX)*2
		var/usefulHeight = (height-1)/2
		for(var/activeY = y - usefulHeight; activeY <= y+usefulHeight; activeY++)
			var/turf/surface/selected = locate(activeX,activeY,z)
			if(!selected) continue
			if(!selected.getMinerals())
				var/datum/mining/mineral/M = new mineral()
				M.setAmount(density)
				M.setQuality(quality)
				selected.setMinerals(M)

//----------------------------------------------------------------------------------------------------------
//DEBUG
/client/verb/verbGenerateMineralDeposit(random as num)
	set category = "Debug - Mining"
	set name = "Generate Mineral Deposit"
	if(!istype(src.mob.loc,/turf/surface))
		src << "Error, cannot generate on non-surface turf."
		return 0
	if(random)
		generateMineralDeposit(src.mob.x,src.mob.y,src.mob.z)
	else
		generateMineralDeposit(src.mob.x,src.mob.y,src.mob.z,6,50,255,/datum/mining/mineral/plasma)

	return 1

/client/verb/verbReadMineralDeposit()
	set category = "Debug - Mining"
	set name = "Read Mineral Deposit"
	if(!istype(src.mob.loc,/turf/surface))
		src << "No mineral deposit can exist on this turf."
		return 0
	var/datum/mining/mineral/M = src.mob.loc:getMinerals()
	if(!M)
		src << "No minerals detected."
		return 0
	src << "Name: [M.getName()]"
	src << "Amount: [M.getAmount()]"
	src << "Quality: [M.getQuality()]"
	return 1

/client/verb/verbSetMineralAmount(amount as num)
	set category = "Debug - Mining"
	set name = "Set Mineral Amount"
	if(!istype(src.mob.loc,/turf/surface))
		return 0
	var/datum/mining/mineral/M = src.mob.loc:getMinerals()
	if(!M) return 0
	M.amount = amount
	return 1

/client/verb/verbTestMineralTable()
	set category = "Debug - Mining"
	set name = "Test Mineral Table"
	generate_mineral_rarity_table()
	for(var/type in mineral_rarity_table)
		src << "[type] -- [mineral_rarity_table[type]]"
	return 1