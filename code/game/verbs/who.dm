/mob/verb/who()
	set name = "Who"

	usr << "<b>Current Players:</b>"

	var/list/peeps = list()

	for (var/mob/M in mobz)
		if (!M.client)
			continue

		if (M.client.stealth && !usr.client.holder)
			peeps += " [M.client.fakekey]"
		else
			peeps += " [M.client][M.client.stealth ? " <i>(as [M.client.fakekey])</i>" : ""] [M.client.holder ? "<font color=\"#b82e00\">([M.client.holder.rank])</font> " : ""]"
	peeps = sortList(peeps)

	for (var/p in peeps)
		usr << p

	usr << "<b>Total Players: [length(peeps)]</b>"

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	usr << "<b>Current Admins:</b>"

	for (var/mob/M in mobz)
		if(M && M.client && M.client.holder && (M.client.holder.rank != "Cluwne") && (M.client.holder.rank != "Gib"))
			if(usr.client.holder)
				usr << "[M.key] - [M.client.holder.rank][M.client.stealth ? " <i>(as [M.client.fakekey])</i>" : ""]"
			else if(!M.client.stealth)
				usr << "\t[M.client] - [M.client.holder.rank]"

/client/verb/cluwnewho()
	set category = "Admin"
	set name = "Cluwnewho"

	usr << "<b>Current Cluwnes:</b>"

	for (var/mob/M in mobz)
		if(M && M.client && M.client.holder)
			if(M.client.holder.rank == "Cluwne")
				usr << "\t[M.client] - [M.client.holder.rank]"
