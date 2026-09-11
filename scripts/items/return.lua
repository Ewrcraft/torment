local Mod = Torment
local ReturnItem = {}
ReturnItem.ID = Isaac.GetItemIdByName("Return")
local ItemPool = Game():GetItemPool()
local player_foritems = Isaac.GetPlayer(0)

function ReturnItem:GetMatterDowngradeFromIID(ct)
	local function removeLocusts()
		local familiars = Isaac.FindByType(EntityType.ENTITY_FAMILIAR)
		if #familiars == 1 then familiars[1]:Remove()
		else familiars[1]:Remove()
		familiars[2]:Remove() end
	end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Treasure") then
		removeLocusts()
	end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Shop") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Secret") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Boss") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Curse") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Angel") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Devil") then removeLocusts() end
	if ct == Isaac.GetItemIdByName("Abyss Matter of Planetatium") then removeLocusts() end
	
end

function ReturnItem:ReturnUse(item)
	local player_foritems = Isaac.GetPlayer(0)
	local history = player_foritems:GetHistory()
	local all_baby_items = {}
	local baby_item_pool_ids = ItemPool:GetCollectiblesFromPool(Isaac.GetPoolIdByName("TormentedApollyonMatterPool"))
	for i = 1, #baby_item_pool_ids do
		table.insert(all_baby_items, baby_item_pool_ids[i].itemID)
	end
	local isaac_has = history:SearchCollectibles(all_baby_items)
	local has_birthright = history:SearchCollectibles(619)
	for i, value in ipairs(isaac_has) do
		if value:GetItemID() == -1 then
			table.remove(isaac_has, i)
			break -- Exit loop after finding and removing the item
		end
	end
	if #isaac_has > 0 then
		player_foritems:RemoveCollectible(isaac_has[1]:GetItemID())
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ItemPool:GetCollectible(-1), player_foritems.Position, Vector.Zero, player_foritems)
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, ReturnItem.ReturnUse, ReturnItem.ID)