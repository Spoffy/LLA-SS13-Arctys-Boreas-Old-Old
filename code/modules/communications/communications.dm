/*
Special frequency list:
On the map:
1435 for status displays
1437 for atmospherics/fire alerts
1439 for engine components
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot control
1449 for airlock controls
1451 for toxin lab access <- Now for every door access system. Shouldn't make any problems i.e. Twatt
1453 for engineering access
1455 for AI access
*/
#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

var/global/datum/controller/radio/radio_controller

datum/controller/radio
	var/list/datum/radio_frequency/frequencies = list()
	var/list/relay_masts = list()

	proc/add_object(obj/device, new_frequency)
		var/datum/radio_frequency/frequency = frequencies[new_frequency]

		if(!frequency)
			frequency = new
			frequency.frequency = new_frequency
			frequencies[new_frequency] = frequency

		frequency.devices += device
		return frequency

	proc/remove_object(obj/device, old_frequency)
		var/datum/radio_frequency/frequency = frequencies[old_frequency]

		if(frequency)
			frequency.devices -= device

			if(frequency.devices.len < 1)
				del(frequency)
				frequencies -= old_frequency

		return 1

	proc/return_frequency(frequency)
		return frequencies[frequency]

	proc/check_radio_range(obj/A, obj/B)
		// Copy across the range so we can change A and B
		var/range = A.radio_range
		var/alt_range = B.radio_range

		if(A.z == 0)
			A = get_turf_loc(A)
		if(B.z == 0)
			B = get_turf_loc(B)

		if(A.z != B.z)
			return 0

		if(alt_range > range)
			range = alt_range

		if(B.x < A.x - range)
			return 0
		if(B.x > A.x + range)
			return 0
		if(B.y < A.y - range)
			return 0
		if(B.y > A.y + range)
			return 0

		return 1



datum/radio_frequency
	var/frequency
	var/list/obj/devices = list()

	proc
		post_signal(obj/source, datum/signal/signal, range)
			var/turf/start_point
			if(range)
				start_point = get_turf(source)
				if(!start_point)
					del(signal)
					return 0

			for(var/obj/device in devices)
				if(device != source)
					if(range)
						var/turf/end_point = get_turf(device)
						if(end_point)
							if(max(abs(start_point.x-end_point.x), abs(start_point.y-end_point.y)) <= range)
								device.receive_signal(signal, TRANSMISSION_RADIO, frequency)
					else
						device.receive_signal(signal, TRANSMISSION_RADIO, frequency)

			del(signal)

obj
	var/radio_range = 0
	proc/receive_signal(datum/signal/signal, receive_method, receive_param)
		return null

datum/signal
	var/obj/source

	var/transmission_method = 0
	//0 = wire
	//1 = radio transmission

	var/data = list()
	var/encryption

	proc/copy_from(datum/signal/model)
		source = model.source
		transmission_method = model.transmission_method
		data = model.data
		encryption = model.encryption