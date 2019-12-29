extends QuestReward
class_name QuestRewardChoice
""" keeps children of type QuestReward to let the player select one 
"""

func _ready():
	for c in self.get_children():
		print('choice: ', c)
