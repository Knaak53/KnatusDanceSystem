--[[ DON'T TOUCH THIS
********************************************************
*   This resource was made and released by Knatus53    *
*   https://github.com/Knaak53 visit my github here    *
*                                                      *
*   Support my work here https://paypal.me/knatus      *
*                                                      *
********************************************************
]] -- DONT TOUCH THIS

local intesityCounter = 1
local animIntensity = {'li','mi','hi'}
local numCounter = 1
local animNum = {'09','11','13','15','17'}
local animVersion = 1
local animType = 1
local animPos = 1
local dancing = false
local gender = ""
local choosed_prop = nil
--[[local possible_props = {
    beer = 'prop_amb_beer_bottle',
    mic = 'prop_microphone_02',
    phone = 'prop_player_phone_01'
}--]] -- No props in dancing until next update , for now no work properly

function table_counter(table_t)
    local count = 0
    for _ in pairs(table_t) do
        count = count + 1 
    end
    return count
  end

RegisterCommand('dance', function(source, args, rawCommand)

    if table_counter(args) == 0 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            args = {"DanceSystem", 'Error: Not enought param, have to specific "male" or "female" dance'}
          })
    end
    if table_counter(args) >= 1 then
        if args[1] == "male" then
            gender = args[1]
            prepareDance()
        elseif args[1] == "female" then
            gender = args[1]
            prepareDance()
        else
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                args = {"DanceSystem", 'Error: The params isnt correct, have to specific "male" or "female" dance'}
              })
        end
        if table_counter(args) == 2 then
            if possible_props[args[2]] ~= nil then
                choosed_prop = possible_props[args[2]]
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    args = {"DanceSystem", 'Error: Dance with props not included at this version of the resource'}
                  })
            end
        end
    end
end)

function dance(action)
    bailoteo(animIntensity[intesityCounter],animNum[numCounter],animVersion,animPos,action)
    Citizen.Wait(2000)
end

function prepareDance ()
    dancing = not dancing

    Citizen.CreateThread(function()
        dance("Dancing!")
        while dancing do
            Wait(0)
            -- Position
            if IsControlJustReleased(1, 117) then
                if animPos < 6 and animPos >=1 then
                    animPos = animPos + 1
                    dance("More Style")
                end
            end
            if IsControlJustReleased(1, 124) then
                if animPos > 1 and animPos <= 6 then
                    animPos = animPos - 1
                    dance("Less Style")
                end
            end
            -- Intensity
            if IsControlJustReleased(1, 111) then
                if intesityCounter < 3 and intesityCounter >= 1 then
                    intesityCounter = intesityCounter + 1
                    dance("More Intensity")
                end
            end
            if IsControlJustReleased(1, 112) then
                if intesityCounter > 1 and intesityCounter <= 3 then
                    intesityCounter = intesityCounter - 1
                    dance("Less Intensity")
                end
            end
            --Number
            if IsControlJustReleased(1, 118) then
                if numCounter < 5 and numCounter >= 1 then
                    numCounter = numCounter + 1
                    dance("Dance number ".. numCounter)
                end
            end
            if IsControlJustReleased(1, 123) then
                if numCounter > 1 and numCounter <= 5 then
                    numCounter = numCounter - 1
                    dance("Dance number ".. numCounter)
                end
            end
            -- Version
            if IsControlJustReleased(1, 314) then
                animVersion = 1
                dance("Version 1")

            end
            if IsControlJustReleased(1, 315) then
                animVersion = 2
                dance("Version 2")
            end
        end
    end)
end

-- Cancel and reset all when "X" is pressed
Citizen.CreateThread(function()
    while true do
        if dancing then
            if IsControlJustReleased(1, 105) then
                dancing = false
                intesityCounter = 1
                numCounter = 1
                animVersion = 1
                animType = 1
                animPos = 1
                dancing = false
                gender = ""
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
        Wait(0)
    end
end)

-- "bailoteo" it just a funny name to call the function, if you work on it, you should refactor and change the name
function bailoteo(animIntensity,animNum,animVersion,animPos, action)
    print(animIntensity.."_dance_facedj_"..animNum.."_v"..animVersion.."_male^"..animPos)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "KnatusDanceSystem",
        duration = 1000,
        label = action,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@nightclub@dancers@crowddance_facedj@",
            anim = animIntensity.."_dance_facedj_"..animNum.."_v"..animVersion.."_"..gender.."^"..animPos,
        },
        prop = {
            model = choosed_prop,
            --bone = GetPedBoneIndex(GetPlayerPed(PlayerId()), 0xeb95), --Dance with props are not working at this versiion
            coords  = {x = 0.055, y = 0.05, z = 0.0},
            rotation = { x = 240.0, y = 0.0, z = 0.0}
        }
    }, function(status)
        if not status then
            -- Do Something If Event Wasn't Cancelled
        end
    end)
end


