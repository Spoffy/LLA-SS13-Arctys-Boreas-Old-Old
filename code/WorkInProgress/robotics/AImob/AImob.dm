//This is the AI unit that controls robotics applications. It should be embedded in an AI core.
//It has to be a mob so a player can control it.

//Design a feature at a time, as with engine.
// 1) Programs and applications. Interface via core
mob/living/robotics/rai
	name = "AI Unit"

	var/list/programs = list()
	var/obj/item/robotics/core/core

	// Add a program to the AI database.
	proc/AddProgram(var/datum/robotics/program)
		if(program)
			programs += program

	// Remove a program from the AI database,
	proc/RemoveProgram(var/program_id)
		if(program_id)
			for(var/i = 1; i <= length(programs); i++)
				var/datum/robotics/program/P = programs[i]
				if(P.program_id == program_id)
					programs -= P

	// Find a program by id.
	proc/FindProgram(var/program_id)
		for(var/datum/robotics/program/P in programs)
			if(P.program_id == program_id)
				return P

	// Display a control panel/program list.
	verb/programs()
		set name = "Programs"
		set category = "AI"

		usr << browse_rsc('grid_background.png',"ai_grid_background.png")
		usr << browse_rsc('top_background.png',"ai_top_background.png")
		usr << browse_rsc('bottom_background.png',"ai_bottom_background.png")
		usr << browse_rsc('divider_gradient.png',"ai_divider_gradient.png")
		usr << browse_rsc('emagged_logo.png',"ai_emagged_logo.png")
		usr << browse_rsc('nanotransen_logo.png',"ai_nanotransen_logo.png")

		var/html = {"
		<center><style>
		body {
			overflow:hidden;
		}

		div {
			position:absolute;
		}


		div#top {
			left:0px;
			top:0px;
			height:15%;
			background-color: grey;
			width:112%;
			z-index:1;
		}

		div#bottom {
			background-image:url('ai_grid_background.png');
			top:15%;
			bottom:0px;
			height:85%;
			width:112%;
			left:0%;
			z-index:1;
		}

		div.top_button {
			width:35%;
			height: 90%;
			top: 5%;
		}

		div.bottom_button {
			position:relative;
			width:50%;
			height:30px;
			margin: 5px;
			left:-3%;
		}

		div.page_switch {
			width:8%;
			height:8%;
			bottom:5%;
		}

		img.hr {
			position:absolute;
			width:112%;
			height: 2px;
			z-index:2;
		}

		img.button {
			position:absolute;
			width: 100%;
			height: 100%;
			left:0%;
			top:0%;
		}

		button {
			position:absolute;
			width:90%;
			height:80%;
			left: 5%;
			top: 11%;
		}
		</style>

		<div id=top>
			<div class=top_button style='left:7%'>
				<img class=button src='ai_top_background.png'>
					<button>Top</button>
				</img>
			</div>
			<div class=top_button style='left:52%'>
				<img class=button src='ai_top_background.png'>
					<button>Top</button>
				</img>
			</div>
		</div>
		<img src='ai_divider_gradient.png' class='hr' style='left:0px;top:15%;'>
		<div id=bottom>
			<img src='ai_nanotransen_logo.png' style='position:absolute;left:22%;top:40%;width:50%;'>

			<div class='bottom_button'>
				<img class=button src='ai_bottom_background.png'>
				<button>Bottom</button>
			</div>
			<div class='bottom_button'>
				<img class=button src='ai_bottom_background.png'>
				<button>Bottom</button>
			</div>

			<div class='page_switch' style='left:82%;'>
				<img class=button src='ai_bottom_background.png'>
				<button>&#8594;</button>
			</div>
			<div class='page_switch' style='left:5%;'>
				<img class=button src='ai_bottom_background.png'>
				<button>&#8592;</button>
			</div>
		</div>
		"}

		html += "</center>"

		usr << browse(html, "window=aipanel;size=380x400;can_resize=0;")

	Topic(href, href_list[])
		if(usr != src)
			return 0
		if(href_list["run"])
			var/datum/robotics/program/P = locate(href_list["run"])
			P.Run(src)
			return 0

	Move(NewLoc, dir, step_x, step_y)
		if(core)
			core.Move(NewLoc, dir, step_x, step_y)
		return

	verb/SpawnBody() // REMOVE
		set name = "Give body"
		set category = "AI"

		var/obj/item/robotics/core/C = new (src.loc)
		C.SetAI(src)
