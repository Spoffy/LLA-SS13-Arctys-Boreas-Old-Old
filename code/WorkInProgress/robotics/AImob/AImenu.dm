/mob/living/robotics/rai
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