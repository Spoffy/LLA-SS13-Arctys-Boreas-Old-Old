// render_menu(html) - Reloads the ai menu with the specified html in the bottom. This is how the menu should be loaded.
// format_console(text) - Returns html of the text surrounded by the console box
// menu_programs(page) - Loads the programs in the bottom of the menu.
// menu_status() - Switched to the status page.
// menu_active_prog() - Loads the menu using the active program's html

/mob/living/robotics/rai
	verb/AImenu()
		set name = "Control Panel"
		set category = "AI"

		menu_status()
		return 1

	//Topic menu
	Topic(href, href_list[])
		if(usr != src)
			return 0
		if(href_list["status"])
			menu_status()
			return 1
		if(href_list["programs"])
			menu_programs()
			return 1
		if(href_list["run"])
			var/datum/robotics/program/P = locate(href_list["run"])
			active_program = P
			P.Run(src)
			menu_active_prog()
			return 1
		if(href_list["page"])
			menu_programs(text2num(href_list["page"]))
			return 1
		if(href_list["active_prog"])
			menu_active_prog()
			return 1

	// HTML rendering function
	proc/render_menu(html_insert)
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

		p {
			position:relative;
			margin: 8px;
			text-align: left;
			font-family:Consolas;
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
			overflow-x: hidden;
			overflow-y: scroll;
		}

		div.top_button {
			width:20%;
			height: 90%;
			top: 5%;
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
			font-family:Consolas;
		}
		</style>
		"}


		html += {"

		<div id=top>
			<div class=top_button style='left:7%'>
				<img class=button src='ai_top_background.png'>
					<button onclick='window.location="?src=\ref[src];status=1;";'>Status</button>
				</img>
			</div>
			<div class=top_button style='left:37%'>
				<img class=button src='ai_top_background.png'>
					<button onclick='window.location="?src=\ref[src];programs=1;";'>Programs</button>
				</img>
			</div>
			<div class=top_button style='left:67%'>
				<img class=button src='ai_top_background.png'>
					<button onclick='window.location="?src=\ref[src];active_prog=1;";'>Active <br> Program</button>
				</img>
			</div>
		</div>

		"}

		html += "<img src='ai_divider_gradient.png' class='hr' style='left:0px;top:15%;'>"
		html += "<img src='ai_[(emagged)? "emagged":"nanotransen"]_logo.png' style='position:absolute;left:22%;top:40%;width:50%;'>"
		html += "<div id=bottom>"

		html += html_insert

		html += "</div>"
		html += "</center>"

		src << browse(html, "window=aipanel;size=380x400;can_resize=0;")

	proc/format_console(text)
		var/html = {"

		<style>
			div#console {
				position:relative;
				border-width: 3px;
				border-color: #7A7A7A;
				border-style: solid;
				background-color: #B8B8B8;
				width: 80%;
				left:-3%;
				margin:5px;
			}

		</style>

		<div id='console'>
			<p class=text>
			[(text)? text : "No Console Text Loaded"]
			</p>
		</div>
		"}

		return html

#define ITEMS_PER_PAGE 8

	proc/menu_programs(page)
		if((page - 1) * ITEMS_PER_PAGE >= length(programs))
			page -= 1
		if(!page) page = 1;

		var/html = {"

		<style>
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
		</style>
		"}

		//8 items per page
		var/page_count = 0
		for(var/datum/robotics/program/P in programs)
			page_count++
			if(page_count <= (page-1)*ITEMS_PER_PAGE)
				continue
			if(page_count > page*ITEMS_PER_PAGE)
				break

			html += {"
			<div class='bottom_button'>
				<img class=button src='ai_bottom_background.png'>
				<button onclick='window.location="?src=\ref[src];run=\ref[P];";'>[P.name]</button>
			</div>
			"}


		html += {"
		<div class='page_switch' style='left:82%;'>
			<img class=button src='ai_bottom_background.png'>
			<button onclick='window.location="?src=\ref[src];page=[page+1];";'>&#8594;</button>
		</div>
		<div class='page_switch' style='left:5%;'>
			<img class=button src='ai_bottom_background.png'>
			<button onclick='window.location="?src=\ref[src];page=[page-1];";'>&#8592;</button>
		</div>
		"}

		render_menu(html)

#undef ITEMS_PER_PAGE

	proc/menu_status()
		var/html = {"
			Active Name: [name]<br>
			Status: Online<br>
			N. Programs Installed: [length(programs)]<br>
			Active Program: [(active_program)? active_program.name : "None"]<br>
			Laws: None <br>
			"}
		html = format_console(html)
		render_menu(html)

	proc/menu_active_prog()
		if(!active_program) return

		render_menu(active_program.html)