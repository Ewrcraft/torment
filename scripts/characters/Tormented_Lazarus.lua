local Mod = Torment

 -- Change every instance of the word "Template" in this file with your character's name, without spaces

local characterCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_template.anm2")

local Template = { -- shown below are default values, as shown on Isaac, for you to change around
    SPEED = 1.00,
    FIREDELAY = 10, -- your tears stat is "30/(FIREDELAY+1)"
    DAMAGE = 3.50, -- is only the damage stat, not damage multiplier
    RANGE = 260, -- your range stat is "40*RANGE"
    SHOTSPEED = 1.00,
    LUCK = 0.00,
    TEARHEIGHT = 0.00, -- these are non default values, instead being additive to the default value because I do not know what the default is
    TEARFALLINGSPEED = 0.00, -- these are non default values, instead being additive to the default value because I do not know what the default is
    TEARFLAG = 0, -- Determines some behaviors of your tears, https://wofsauge.github.io/IsaacDocs/rep/enums/TearFlags.html
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), -- r1.0 g1.0 b1.0 a1.0 0r 0g 0b (the last three are offsets)
    FLYING = false
}

function Mod:onCache(player, cacheFlag)
    if player:GetName() == "Tormented Lazarus" then
        player:AddNullCostume(characterCostume)
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed - 1 + Template.SPEED
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 10 + Template.FIREDELAY
        end
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
			print("Evaluated DMG")
            player.Damage = player.Damage - 3.5 + Template.DAMAGE
			if LazarusDamageDownCache.NeedToReeval == true then
				player.Damage = player.Damage - 3.5 + Template.DAMAGE + LazarusDamageDownCache.Cache
			end
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange - 260 + Template.RANGE
            player.TearHeight = player.TearHeight + Template.TEARHEIGHT
            player.TearFallingSpeed = player.TearFallingSpeed + Template.TEARFALLINGSPEED
        end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed - 1 + Template.SHOTSPEED
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + Template.LUCK
        end
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | Template.TEARFLAG -- The OR here makes sure that if you have an item that changes tear flags, the values you set takes priority
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Template.TEARCOLOR
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and Template.FLYING then
            player.CanFly = true
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.onCache)


local function onStart(_,bool)
    print(bool)
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)

local function OnRunStartLaz(_,bool)
	player = Isaac.GetPlayer(0)
	print("OnRunStart correctly called, IsContinued: ")
	print(bool)
	if not bool then
		LazarusDamageDownCache.NeedToReeval = true
		LazarusDamageDownCache.Cache = 0
		print("Ran the not continued branch")
	end
	if bool then
		LazarusDamageDownCache.NeedToReeval = true
		player.Damage = player.Damage + LazarusDamageDownCache.Cache
		print("Ran the continued branch")
	end
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, OnRunStartLaz)

function Mod:TormentedLazarusInit(player)
	--LazarusDamageDownCache = EntitySaveStateManager.GetEntityData(Mod, player)
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.TormentedLazarusInit)

function Mod:LazarusConstantDamageDrain(player)
	if player:GetName() == "Tormented Lazarus" then
		player.Damage = player.Damage - 0.0005
		LazarusDamageDownCache.Cache = LazarusDamageDownCache.Cache - 0.0005
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.LazarusConstantDamageDrain)

function Mod:LazarusOnDMGDMGUpCall(entity, damage, DamageFlags, Source, cdFrames)
	if entity:ToPlayer() ~= nil then
		if (entity:ToPlayer():GetName() == "Tormented Lazarus") then
			player = entity:ToPlayer()
			player.Damage = player.Damage + damage*(0.67)
			LazarusDamageDownCache.Cache = LazarusDamageDownCache.Cache + 0.67
			if LazarusDamageDownCache.WasJustRevived then
				LazarusDamageDownCache.WasJustRevived = false
			end
			print(cdFrames)
		end
	end
end

-- The damage given is a rounding of 2/3, not a meme reference

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.LazarusOnDMGDMGUpCall)

function Mod:TormentedLazarusReviveManagement(player)
	if player:GetEffects():HasNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie")) then
		player:GetEffects():RemoveNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"), 1)
		player:Revive()
		LazarusDamageDownCache.WasJustRevived = true
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, Mod.TormentedLazarusReviveManagement)

function Mod:TormentedLazarusFullHPOnRevive(player)
	player:AddHearts(player:GetMaxHearts()-1)
	--player:AddSoulHearts(1) does not infact cure not having i-frames
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, Mod.TormentedLazarusFullHPOnRevive)

function Mod:TormentedLazarusReviveAdding()
	player = Isaac.GetPlayer()
	if player:GetName() == "Tormented Lazarus" then
		numRevives = player:GetEffects():GetNullEffectNum(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
		if numRevives == 3 then
		end
		if numRevives == 2 then
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
		end
		if numRevives == 1 then
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
		end
		if numRevives == 0 then
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
			player:GetEffects():AddNullEffect(Isaac.GetNullItemIdByName("LazarusReviveThingie"))
		end
	end
	-- I am waaaay to tired to be fancy, no one's looking at the code anyways. Timestamp: 1:54 AM
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.TormentedLazarusReviveAdding)