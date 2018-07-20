require 'default:globals.dynamic_window.prestige'

-- DAB TODO: Don't copy paste functions!
function RegisterPrestigeAdminHandlers(playerObj)
    RegisterEventHandler(EventType.ClientUserCommand, "prestige", function(prestigeClass, abilityName, level, slot)
        PrestigeAbilityWindow(playerObj, prestigeClass, abilityName, level, slot)
    end)

    RegisterEventHandler(EventType.ClientUserCommand,"makebook",function(prestigeAbility,abilityLevel)
        if not ( prestigeAbility ) then
            playerObj:SystemMessage("Please specify a prestige ability.")
            return
        end

        GiveMobileMinimumSkillXpForAbility(playerObj, prestigeAbility, abilityLevel)

        RegisterSingleEventHandler(EventType.CreatedObject,"book_created",function (success,objRef)
            objRef:SendMessage("SetBook",prestigeAbility,abilityLevel)
        end)

        CreateObj("prestige_ability_book_blank", playerObj:GetLoc(), "book_created")
    end)
end