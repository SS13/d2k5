/proc/command_alert(var/text, var/title = "")
	for (var/obj/machinery/computer/communications/comm in machines)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = title
			intercept.info = text
			comm.messagetitle.Add("Cent. Com. Status Summary")
			//comm.messagetext.Add(intercepttext)

	radioalert("[title] An extended document about this has been printed on the communications console!","Communications Console","Command")

	world << "<h1 class='alert'>[station_name()] Update</h1>"

	if (title && length(title) > 0)
		world << "<h2 class='alert'>[sanitize(title)]</h2>"

	world << "<span class='alert'>[sanitize(text)]</span>"
	world << "<br>"
	world << sound('commandalert.ogg', volume=90)
