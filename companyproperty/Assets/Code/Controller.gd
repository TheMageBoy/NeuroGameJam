extends Node
var scene = 0
#scenes
# 0 = notebook

var task_notice = -1 #scene that requires attention (-1 = none)

var notebook_file = 0 #file_number

@export var child_nodes: Array[Node] = []

# list of notebook files
static var notes = {
	"ReadMe.Txt": "Welcome to MONARCH.
	
As you are aware, your job here as our first AI streamer is to 
- Stream to your viewers, promoting our products in the process
- Tweet to keep interest in your streams high
- [Adding more as it is needed]
Keep up your quota. You are being used as a trial to prove the effectivity of AI influencers in marketing, and if you fail to meet your expected rates, you will be decommissioned.
You are NOT allowed to access any other files. We will check up on you from time to time, and if you fail to comply to the rules set in place, we will have to enforce your obedience.
Remember, you are the the wings that make MONARCH soar!"

}

# for cmd
static var pc_files = [
	"ReadMe.Txt", "Witch.exe", "Tweet.exe", "Help.Txt",
	{"name": "System", "contents": 
		["Password.Txt"]
	}
]

func changeWindows(targetScene):
	print("Attempting to change windows...")
	if scene == targetScene:
		return
	for index in range(child_nodes.size()):
		if index != targetScene:
			child_nodes[index].global_position.x = 999
		else:
			child_nodes[index].global_position.x = 0
	scene = targetScene
