Torment = RegisterMod("Torment", 1)
LazarusDamageDownCache = {}
LazarusDamageDownCache.Cache = 0

-- If you came here to look how code works DON'T
-- NUH UH
-- Bad idea. The code is messy
-- you should go to #isaac-mod-dev on isaac dc, or isaac official docs and isaac blueprints as well

print("I ran or Iran")

local Mod = Torment

include("scripts/items/sacrifice")
include("scripts/items/forbidden_dice")
include("scripts/characters/Tormented_Lilith")
include("scripts/characters/Tormented_Lost")
include("scripts/characters/Tormented_Lazarus")
include("scripts/helpers/CacheCallBackManager")