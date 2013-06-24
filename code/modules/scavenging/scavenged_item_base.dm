obj/scavenging/item
	name = "Generic Scavenged Item Base"
	desc = "This really shouldn't be here."
	anchored = 1
	density = 1
	opacity = 0

	var/event_chance = 10
	var/state = 1
	var/list/sequence = list()
	var/list/fixed_rewards = list()
	var/list/random_rewards = list()
	var/rand_reward_quant = 1


	New()
		..()
		setup_item()
		if(sequence.len == 0 || (fixed_rewards.len == 0 && random_rewards.len == 0))
			del src
			return 0

	proc/setup_item()
		//CODE GOES HERE BROS. SEE EXAMPLE.
		return 0

	proc/handle_sequence(datum/scavenging/sequence/current_sequence,mob/user,obj/item/tool)
		user << current_sequence.get_message()
		if(current_sequence.get_icon_state())
			icon_state = current_sequence.get_icon_state()

		handle_state_change(tool)

		if(rand(1,100) <= event_chance)
			handle_event()

		state++
		if(state > sequence.len)
			give_reward()
		return 1

	attackby(obj/item/W, mob/user)
		var/datum/scavenging/sequence/current_sequence = sequence[state]
		if(current_sequence.get_tool() == W.type)
			handle_sequence(current_sequence,user,W)
			return 1
		else
			..()

	attack_hand(mob/user)
		var/datum/scavenging/sequence/current_sequence = sequence[state]
		if(current_sequence.get_tool() == "hand")
			handle_sequence(current_sequence,user,"hand")
			return 1
		else
			..()

	proc/give_reward()
		for(var/reward_path in fixed_rewards)
			new reward_path(src.loc)
		if(length(random_rewards))
			for(var/i = 1; i <= rand_reward_quant;i++)
				var/random_path = pick(random_rewards)
				new random_path(src.loc)
		visible_message("The [name] has been dismantled. You salvage some equipment from the remains!","You hear something fall apart nearby.")
		del src

	proc/add_sequence_item(tool,message,icon_state)
		var/datum/scavenging/sequence/addition = new /datum/scavenging/sequence(tool,message,icon_state)
		if(!addition)
			world.log <<"ERROR: Attempted to add invalid sequence item. Item [tool] failed to be added to [type]"
			return 0
		sequence += addition
		return 1

	proc/add_fixedreward(reward_path)
		fixed_rewards += reward_path
		return 1

	proc/add_randomreward(reward_path)
		random_rewards += reward_path
		return 1

	proc/handle_event()
		return 1

	proc/handle_state_change(obj/item/tool)
		return 1


datum/scavenging/sequence
	var/tool = null
	var/message = "You further dismantle the component."
	var/icon_state = null

	New(var/tool_path,var/action_message,var/new_state)
		..()
		if(!tool_path)
			del src
			return 0
		else
			tool = tool_path
		if(action_message)
			message = action_message
		if(new_state)
			icon_state = new_state

	proc/get_icon_state()
		return icon_state

	proc/get_message()
		return message

	proc/get_tool()
		return tool