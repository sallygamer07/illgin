extends Node


export(String) var quest_name = "화관의 재료"

export(String) var required_item = "싱싱한 꽃"
export(int) var required_amount = 10
export(String) var reward_item = "하급 회복 포션"
export(int) var reward_amount = 1

export(String, MULTILINE) var initial_text = "화관을 만들고 싶은데, 시간이 없어서요.\n혹시 꽃을 10송이 꺾어와주실 수 있나요?"
export(String, MULTILINE) var pending_text = "잊으셨나요? 제가 원하는 건 꽃 10송이에요."
export(String, MULTILINE) var delivered_text = "고마워요! 이제 보상을 드릴게요!"

func process() -> String:
	var quest_status = Quest.get_status(quest_name)
	match quest_status:
		Quest.STATUS.NONEXISTENT:
			var _e_rr = Quest.accept_quest(quest_name)
			return initial_text
		Quest.STATUS.STARTED:
			var getting_item = PlayerInventory.get_item(required_item)
			if getting_item != null:
				if getting_item >= required_amount:
					for item in PlayerInventory.hotbar:
						if PlayerInventory.hotbar[item].has(getting_item):
							var _err_ = PlayerInventory.remove_item_quest(required_item, required_amount)
							var _quest = PlayerInventory.quest_succ()
					for _item in PlayerInventory.inventory:
						if PlayerInventory.inventory[_item].has(getting_item):
							var _err_ = PlayerInventory.remove_item_quest(required_item, required_amount)
							var _quest_ = PlayerInventory.quest_succ()
					var _er_r_ = Quest.change_status(quest_name, Quest.STATUS.COMPLETE)
					var _e_rr_ = Quest.remove_quest(quest_name)
					PlayerInventory.add_item(reward_item, reward_amount)
					return delivered_text
				else:
					return pending_text
			else:
				return pending_text
		_:
			return ""
