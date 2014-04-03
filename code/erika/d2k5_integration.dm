//Do Bank Transaction
//Amount can be negative or positive. If you use a negative amount it will take that amount from the members forum bank.
//You can do transactions as low as 0.01
//It returns 1 if the transaction went through and 0 if it did not, just in case you need to verify.
//Transactions will not go through if the user doesn't have enough money or there was some other error.

var/list/donators = list()

/proc/load_donators()
	if(donators.len)
		return
	var/DBConnection/dbcon = new()
	dbcon.Connect("dbi:mysql:forum2:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(!dbcon.IsConnected())
		diary << "load_donators ERROR [dbcon.ErrorMsg()]"
		donators["fail"] = 1
		return "no key found"
	var/DBQuery/query = dbcon.NewQuery("SELECT byond,sum FROM Z_donators")
	query.Execute()
	while(query.NextRow())
		donators[query.item[1]] = round(query.item[2])
	dbcon.Disconnect()

//Usage: doTransaction(<ckey>,<amount>,<description>)
/datum/proc/doTransaction(ckey,amount,description)
	if(!donators[ckey])
		return "no key found"
	if(text2num(amount) > 0)
		score_moneyearned += text2num(amount)
		donators[ckey] += amount
		log_game("Transaction: [ckey] Amount: [amount] Description: [description]")
		return 1
	if(text2num(amount) < 0)
		if(donators[ckey] < -amount)
			return 0
		donators[ckey] -= amount
		score_moneyspent += text2num(amount)
		log_game("Transaction: [ckey] Amount: [amount] Description: [description]")
		return 1

/datum/proc/getBalance(ckey)
	if(donators[ckey])
		return donators[ckey]
	return "no key found"

//Usage: getInflation()
/datum/proc/getInflation()
	return 0

/mob/verb/memory()
	set name = "View Mind"
	set category = "Mind"
	if(mind)
		mind.show_memory(src)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/add_memory(msg as message)
	set name = "Add Thought"
	set category = "Mind"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/StopMusic()
	set name = "Mute Sounds (until rejoin)"
	set category = "Commands"
	src << browse("", "window=rpane.hosttracker")
