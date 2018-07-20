require 'incl_container'
require 'incl_packed_object'

alldecorations = {
	"arena_dummy",
	"barrel",
	"barrel_holder",
	"barrel_inn",
	"barrel_open",
	"barrel_wine",
	"cage_hanging_sewer",
	"campfire",
	"campfire_cultist",
	"campfire_large",
	"canopy_mining",
	"clothesline_large",
	"clothesline_small",
	"coffin01",
	"coffin02",
	"coffin03",
	"coffin04",
	"coffin05",
	"coffin06",
	"coffin07",
	"coffin08",
	"coffin09",
	"crate_empty",
	"crate_mine_cloth_large",
	"crate_mine_large",
	"crate_open_empty",
	"cultist_campfire_2",
	"cultist_cheval",
	"cultist_spear_head",
	"fence_mine",
	"fence_small",
	"fence_small_single",
	"flag_arena",
	"flag_cultist",
	"flag_water",
	"fountain",
	--"furniture_anvil",
	"furniture_bed_large",
	"furniture_bed_medium",
	"furniture_bed_roll",
	"furniture_bed_small",
	"furniture_bench_celador",
	"furniture_bench_fancy",
	"furniture_bench_stone",
	"furniture_bookshelf_wooden",
	"furniture_bookshelf_wooden_empty",
	"furniture_candelabra",
	"furniture_carpet_blue",
	"furniture_carpet_cloth",
	"furniture_chair",
	"furniture_chair_fancy",
	"furniture_chair_wooden",
	"furniture_chandelier_inn",
	"furniture_curtain_divider",
	"furniture_desk_fancy",
	"furniture_desk_wooden",
	"furniture_drawer_wooden",
	"furniture_dresser",
	"furniture_fireplace_stone",
	"furniture_luggage_leather",
	"furniture_panel_divider",
	"furniture_rug_circle",
	"furniture_rug_square",
	"furniture_shelf",
	"furniture_table_blacksmith",
	"furniture_table_cultist",
	"furniture_table_inn",
	"furniture_table_mining",
	"furniture_table_wooden",
	"furniture_table_wooden_large",
	"furniture_table_wooden_plank",
	"furniture_weapon_rack",
	"lantern_street",
	"lantern_line",
	"mine_cart",
	"mine_cart_no_wheels",
	"pillar_ruins",
	"pillar_single_ruins",
	"pillar_stone",
	"spike",
	"spike_bloody",
	"stove",
	"tent_blue_large",
	"tent_dome_small",
	"tent_red_large",
	"tent_wood_small",
	"tool_forge",
	"wall_graveyard",
	"wall_half_graveyard",
	"well",
	"workbench_crafting",
	"ash_tray",
	"candle",
	"candle_table",
	"feather_holder",
	"furniture_luggage_wooden_1",
	"furniture_luggage_wooden_2",
	"furniture_luggage_wooden_3",
	"furniture_painting1",
	"furniture_painting2",
	"furniture_painting3",
	"furniture_painting4",
	"furniture_painting5",
	"furniture_pot_ceramic_1",
	"furniture_pot_ceramic_2",
	"furniture_pot_ceramic_3",
	"furniture_stool_inn",
	"furniture_stool_wooden",
	"ink_container",
	"item_bowl",
	"lantern_table",
	"mug",
	"parchment_paper",
	"tool_cookingpot",
	"torch_gothic",
	"treasurechest",
	"treasurechest_bone",
	"world_torch",
	"animalparts_human_skull",
	"lockbox",
	"artifact_flute",
	"artifact_gold_bracelet",
	"artifact_mask",
	"artifact_ornate_goblet",
	"artifact_ornate_pottery",
	"artifact_pendant",
	"artifact_small_statue",
	"item_beer",
	"item_mead",
	"book_brown",
	"book_green",
	"book_grey",
	"book_red",
	"chest_autodelete",
}

templateListPage = 1
function ShowPlacableDecoTemplates(user)
	local newWindow = DynamicWindow("DecoTemplateList","Create Decoration",450,650)
	local x = 20
	local y = 10
	local rowIndex = 1
	local itemsPerPage = 18
	local startIndex = ((templateListPage-1) * itemsPerPage) + 1
	local commandIndex = 1

	local decoSorted = {}
	for i,decoTemplate in ipairs(alldecorations) do	
		entryName = StripColorFromString(GetTemplateObjectName(decoTemplate))
		if(entryName == nil or entryName == "") then
			entryName = decoTemplate
		end	
		table.insert(decoSorted,{EntryName=entryName,DecoTemplate=decoTemplate})
	end
	table.sort(decoSorted,function(a,b) return a.EntryName < b.EntryName end)

	for i,deco in ipairs(decoSorted) do		
		if( commandIndex >= startIndex  and commandIndex < startIndex + itemsPerPage) then
			tooltip = ""
			
			newWindow:AddButton(x, y, "create:"..deco.DecoTemplate,deco.EntryName, 350, 0, "", "", false)
			if( rowIndex == 1 ) then
				x = 20
				y = y + 30
				rowIndex = 1
			else
				x = x + 200
				rowIndex = 1
			end			
		end
		commandIndex = commandIndex + 1
	end
	
	if( templateListPage > 1 ) then
		newWindow:AddButton(180, 580, "UserListPrev:", "Previous", 100, 0, "", "", false)
	end
	if( templateListPage <= (commandIndex-1) / itemsPerPage) then
		newWindow:AddButton(300, 580, "UserListNext:", "Next", 100, 0, "", "", false)
	end
	user:OpenDynamicWindow(newWindow)
end

function DoDecoCreate(user, templateId)
	local weight = GetTemplateObjectProperty(templateId,"Weight")

	if(weight == -1) then
		CreatePackedObject(user,templateId)		
	else
		CreateObjInBackpackOrAtLocation(user, templateId)		
	end

	entryName = StripColorFromString(GetTemplateObjectName(templateId))
	if(entryName == nil or entryName == "") then
		entryName = templateId
	end	
	user:SystemMessage(entryName.. " created in your backpack.")
end

RegisterEventHandler(EventType.DynamicWindowResponse,"DecoTemplateList",
	function (user,returnId)
		if(returnId ~= nil) then
			action, template = string.match(returnId, "(%a+):([%a_%d]*)")
			if(action == "create") then				
				if( template ~= nil ) then
					DoDecoCreate(user,template)
				end
			elseif(action == "UserListNext") then
				templateListPage = templateListPage + 1
				ShowPlacableDecoTemplates(user)
			elseif( action == "UserListPrev") then
				templateListPage = templateListPage - 1
				ShowPlacableDecoTemplates(user)
			elseif( action == "CreateFilter") then
				user:SendClientMessage("EnterChat",".xo "..user.Id.." createfilter ")
			end
		end	
	end)

RegisterEventHandler(EventType.Message,"ShowDecoCreateWindow",
	function(user)
		templateListPage = 1
		ShowPlacableDecoTemplates(user)
	end)