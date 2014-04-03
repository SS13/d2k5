var/list/cluwnelist

#define CLUWNELISTFILE "data/cluwne.txt"
/proc/load_cluwnelist()
	var/text = file2text(CLUWNELISTFILE)
	if (!text)
		diary << "Failed to [CLUWNELISTFILE]\n"
	else
		cluwnelist = dd_text2list(text, "\n")

/proc/check_cluwnelist(mob/M /*, var/rank*/)
	if(!cluwnelist)
		return 0
	return ("[M.ckey]" in cluwnelist)

#undef CLUWNELISTFILE