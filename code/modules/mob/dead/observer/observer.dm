/mob/dead/observer/New(mob/body, var/safety = 0)
	invisibility = 10
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = 15
	see_in_dark = 100
	verbs += /mob/dead/observer/proc/dead_tele

	if(body)
		var/turf/location = get_turf(body)//Where is the mob located?
		if(location)//Found turf.
			loc = location
		else//Safety, in case a turf cannot be found.
			loc = pick(latejoin)
		real_name = body.real_name
		name = body.real_name
		icon = getGhostIcon(icon(body:stand_icon))
		attack_log = body.attack_log

		var/g = "m"
		if (body:gender == MALE)
			g = "m"
		else if (body:gender == FEMALE)
			g = "f"

		overlays += getGhostIcon(new/icon("icon" = 'human_face.dmi', "icon_state" = "[body:hair_icon_state]_s"))
		overlays += getGhostIcon(new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_s"))
		overlays += getGhostIcon(new/icon("icon" = 'human_face.dmi', "icon_state" = "[body:face_icon_state]_s"))
		overlays += getGhostIcon(new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_s"))
		if(!safety)
			corpse = body
			verbs += /mob/dead/observer/proc/reenter_corpse
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(var/transfer_mind = 0)
	if(key)
		if(client)
			client.screen.len = null//Clear the hud, just to be sure.
		var/mob/dead/observer/ghost = new(src,transfer_mind)//Transfer safety to observer spawning proc.
		if(transfer_mind)//When a body is destroyed.
			if(mind)
				mind.transfer_to(ghost)
			else//They may not have a mind and be gibbed/destroyed.
				ghost.key = key
		else//Else just modify their key and connect them.
			ghost.key = key

		verbs -= /mob/proc/ghost
		if (ghost.client)
			ghost.client.eye = ghost

	else if(transfer_mind)//Body getting destroyed but the person is not present inside.
		for(var/mob/dead/observer/O in mobz)
			if(O.corpse == src&&O.key)//If they have the same corpse and are keyed.
				if(mind)
					O.mind = mind//Transfer their mind if they have one.
				break
	return

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/proc/ghost()
	set category = "Ghost"
	set name = "Ghost"
	set desc = "You cannot be revived as a ghost."

	/*if(stat != 2) //this check causes nothing but troubles. Commented out for Nar-Sie's sake. --rastaf0
		src << "Only dead people and admins get to ghost, and admins don't use this verb to ghost while alive."
		return*/
	if(key)
		var/mob/dead/observer/ghost = new(src)
		ghost.key = key
		verbs -= /mob/proc/ghost
		if (ghost.client)
			ghost.client.eye = ghost
			sleep(5)
			ghost.cancel_camera(1)
	return

/mob/proc/adminghostize()
	if(client)
		client.mob = new/mob/dead/observer(src)
	return

/mob/dead/observer/Move(NewLoc, direct)
	if(NewLoc)
		loc = NewLoc
		return
	if((direct & NORTH) && y < world.maxy)
		y++
	if((direct & SOUTH) && y > 1)
		y--
	if((direct & EAST) && x < world.maxx)
		x++
	if((direct & WEST) && x > 1)
		x--

/mob/dead/observer/examine()
	if(usr)
		usr << desc

/mob/dead/observer/can_use_hands()	return 0
/mob/dead/observer/is_active()		return 0

/mob/dead/observer/Stat()
	..()
	statpanel("Status")
	if (client.statpanel == "Status")
		if(ticker)
			if((ticker.current_state == GAME_STATE_PLAYING) && (src.client))
				if(src.client)
					if(src.pixel_y == 0)
						src.pixel_y = 1
						sleep(3)
					if(src.pixel_y == 1)
						src.pixel_y = 2
						sleep(3)
					if(src.pixel_y == 2)
						src.pixel_y = 1
						sleep(3)
					if(src.pixel_y == 1)
						src.pixel_y = 0
						sleep(3)
					if(src.pixel_y == 0)
						src.pixel_y = -1
						sleep(3)
					if(src.pixel_y == -1)
						src.pixel_y = -2
						sleep(3)
					if(src.pixel_y == -2)
						src.pixel_y = -1
						sleep(3)
					if(src.pixel_y == -1)
						src.pixel_y = 0
				if(!resptim)
					resptim = world.time
				else if(world.time - resptim > 600)
					resptime -= 1
					resptim = 0
				if(resptime <= -1)
					resptime = 1
				if ((resptime == 0) && (src.client))
					var/respawnprice = 0
					respawnprice = text2num(src.getInflation())
					respawnprice = respawnprice + 700
					usr << "You may now respawn if you wish!"
					if(alert("Do you wish to respawn? This will cost you ϛrespawnprice]!",,"Yes","No")=="Yes")
						if(src.doTransaction(usr.ckey,"-[respawnprice]","Respawn."))
							usr << "\blue Purchase successful."
							usr << "\red <font size=5><B>HEY DUMB FUCK, YOU HAVE JUST BEEN RESPAWNED, RULES FOR THIS ARE THE FOLLOWING:</B></font>"
							usr << "\red <font size=5>1. YOU MUST USE A DIFFERENT NAME OTHER THAN THE ONE YOU DIED WITH</font>"
							usr << "\red <font size=5>2. YOU CAN NOT USE ANY INFORMATION FROM YOUR PREVIOUS CHARACTER</font>"
							usr << "\red <BR><font size=5><B>YOU WILL BE PERMABANNED ON SIGHT IF YOU BREAK EITHER OF THESE. WE ARE WATCHING YOU.</B></font>"
							respcounter += 1
							if(respcounter > 0)
								resptime += 20
							if(!src.client)
								log_game("[usr.key] AM failed due to disconnect.")
								return
							for(var/obj/screen/t in usr.client.screen)
								if (t.loc == null)
									//t = null
									del(t)
							if(!src.client)
								log_game("[usr.key] AM failed due to disconnect.")
								return

							var/mob/new_player/M = new /mob/new_player()
							if(!src.client)
								log_game("[usr.key] AM failed due to disconnect.")
								del(M)
								return



							M.key = src.client.key
							M.Login()
						else
							usr << "\red Purchase failed (possibly insufficient funds or missing bank account)."
							resptime = 10
					else
						resptime = 10
				stat(null, "Time Until Respawn: [resptime] minutes")
			if(ticker.mode)
				//world << "DEBUG: ticker not null"
				if(ticker.mode.name == "AI malfunction")
					//world << "DEBUG: malf mode ticker test"
					if(ticker.mode:malf_mode_declared)
						stat(null, "Time left: [max(ticker.mode:AI_win_timeleft/(ticker.mode:apcs/3), 0)]")
		if(emergency_shuttle)
			if(emergency_shuttle.online && emergency_shuttle.location < 2)
				var/timeleft = emergency_shuttle.timeleft()
				if (timeleft)
					stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/dead/observer/proc/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!corpse)
		alert("You don't have a corpse!")
		return
	if(client && client.holder && client.holder.state == 2)
		var/rank = client.holder.rank
		client.clear_admin_verbs()
		client.holder.state = 1
		client.update_admins(rank)
	if(iscultist(corpse) && corpse.ajourn==1 && corpse.stat!=2) //checks if it's an astral-journeying cultistm if it is and he's not on an astral journey rune, re-entering won't work
		var/S=0
		for(var/obj/rune/R in world)
			if(corpse.loc==R.loc && R.word1 == wordhell && R.word2 == wordtravel && R.word3 == wordself)
				S=1
		if(!S)
			usr << "\red The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you."
			return
	if(corpse.ajourn)
		corpse.ajourn=0
	client.mob = corpse
	if (corpse.stat==2)
		verbs += /mob/proc/ghost
	del(src)

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport"
	if((usr.stat != 2) || !istype(usr, /mob/dead/observer))
		usr << "Not when you're not dead!"
		return
	usr.verbs -= /mob/dead/observer/proc/dead_tele
	spawn(30)
		usr.verbs += /mob/dead/observer/proc/dead_tele
	var/A
	A = input("Area to jump to", "BOOYEA", A) in ghostteleportlocs
	var/area/thearea = ghostteleportlocs[A]

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T
	usr.loc = pick(L)

/mob/dead/observer/verb/toggle_alien_candidate()
	set name = "Toggle Be Alien Candidate"
	set category = "Ghost"
	set desc = "Determines whether you will or will not be an alien candidate when someone bursts."
	if(client.be_alien)
		client.be_alien = 0
		src << "You are now excluded from alien candidate lists until end of round."
	else if(!client.be_alien)
		client.be_alien = 1
		src << "You are now included in alien candidate lists until end of round."

/mob/dead/observer/memory()
	set hidden = 1
	src << "\red You are dead! You have no mind to store memory!"

/mob/dead/observer/add_memory()
	set hidden = 1
	src << "\red You are dead! You have no mind to store memory!"

