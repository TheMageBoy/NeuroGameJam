extends UI_Window

# I think twitch streaming should be the mini game that adds a big chunk back to the progress bar, but makes it lower faster

var window_width = 10
static var message_list = [
	#[message, weight]
	["L", 20],
	["Streamer fell off", 1],
	["Bring back the old Neuro!", 1],
	["WTF did they do to her", 1],
	["Cringe", 5],
	["Jeez, what happened to Neuro? She used to be so much more fun…", 1],
	["Not my Neuro", 1]
]

func rollTwitchMessage():
	var total = 0
	for message in message_list:
		total += message[1]
	var roll = randi() % total
	for message in message_list:
		roll -= message[1]
		if roll < 0:
			return message[0]
