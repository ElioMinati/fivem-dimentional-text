local textArray = {}
local anyTextShowing = false

function Draw3DTextTimeout(id, coords, text, radius, perspectiveScale, timeout)
    if timeout == nil then
        print("Invalid Timeout for the 3D Text.")
        return
    end
    if coords == nil then
        print("Invalid Coordinates for the permanent 3D text display.")
        return
    end
    if radius == nil then
        print("Invalid Radius for permanent 3D text display.")
        return
    end
    if perspectiveScale == nil then
        perspectiveScale = 4
    end

    -- Text error handling / default value replacing
    if text == nil then
        print("Please specify the text argument for the permanent 3D Text.")
        return
    else
        if text.content == nil then
            print("Please specify the text.content for the permanent 3D Text.")
            return
        end
        if text.font == nil then
            text.font = 0
        end
        if text.rgba == nil then
            text.rgba = {255, 255, 255, 255}
        end
        if text.textOutline == nil then
            text.textOutline = true
        end
        if text.scaleMultiplier == nil then
            text.scaleMultiplier = 1
        end
    end
    -- if rect == nil then
    --     rect = {draw = false}
    -- elseif rect.draw then
    --     if rect.rgba == nil then
    --         rect.rgba = {1, 1, 1, 155}
    --     end
    -- end
    table.insert(textArray, {id = id, parameters = {xyz = coords, radius = radius, perspectiveScale = perspectiveScale, text = text}, show = false});
    local timeoutIndex = #textArray
    Citizen.CreateThread(function()
        Wait(timeout)
        table.remove(textArray, timeoutIndex)
    end)
end

function Draw3DTextPermanent(id, coords, text, radius, perspectiveScale)
    if coords == nil then
        print("Invalid Coordinates for the permanent 3D text display.")
        return
    end
    if radius == nil then
        print("Invalid Radius for permanent 3D text display.")
        return
    end
    if perspectiveScale == nil then
        perspectiveScale = 4
    end
    if text == nil then
        print("Please specify the text argument for the permanent 3D Text.")
        return
    else
        if text.content == nil then
            print("Please specify the text.content for the permanent 3D Text.")
            return
        end
        if text.font == nil then
            text.font = 0
        end
        if text.rgba == nil then
            text.rgba = {255, 255, 255, 255}
        end
        if text.textOutline == nil then
            text.textOutline = true
        end
        if text.scaleMultiplier == nil then
            text.scaleMultiplier = 1
        end
    end
    -- if rect == nil then
    --     rect = {draw = false}
    -- elseif rect.draw then
    --     if rect.rgba == nil then
    --         rect.rgba = {1, 1, 1, 155}
    --     end
    -- end
    table.insert(textArray, {id = id, parameters = {xyz = coords, radius = radius, perspectiveScale = perspectiveScale, text = text}, show = false});
end

function Draw3DTextThisFrame(coords, text, radius, perspectiveScale)
    if coords == nil then
        print("Invalid Coordinates for this frame 3D text display.")
        return
    end
    if radius == nil then
        print("Invalid Radius for this frame 3D text display.")
        return
    end
    if perspectiveScale == nil then
        perspectiveScale = 4
    end
    if text == nil then
        print("Please specify the text argument for this frame 3D Text.")
        return
    else
        if text.content == nil then
            print("Please specify the text.content for this frame 3D Text.")
            return
        end
        if text.font == nil then
            text.font = 0
        end
        if text.rgba == nil then
            text.rgba = {255, 255, 255, 255}
        end
        if text.textOutline == nil then
            text.textOutline = true
        end
        if text.scaleMultiplier == nil then
            text.scaleMultiplier = 1
        end
    end
    -- if rect == nil then
    --     rect = {draw = false}
    -- elseif rect.draw then
    --     if rect.rgba == nil then
    --         rect.rgba = {1, 1, 1, 155}
    --     end
    -- end

    if Vdist2(GetEntityCoords(PlayerPedId(), false), coords.x, coords.y, coords.z) < radius then
        local p = GetGameplayCamCoords()
        local fov = (1 / GetGameplayCamFov()) * 75
        local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
        if onScreen then
            local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, coords.x, coords.y, coords.z, 1)
            local scale = (1 / distance) * perspectiveScale
            scale = scale * fov * text.scaleMultiplier
            SetTextScale(0.0, scale)
            SetTextFont(text.font)
            SetTextProportional(true)
            SetTextColour(text.rgba[1], text.rgba[2], text.rgba[3], text.rgba[4])
            --SetTextDropshadow(0, 0, 0, 0, 255)
            --SetTextEdge(2, 0, 0, 0, 150)
            if text.textOutline then
                SetTextOutline()
            end
            SetTextCentre(true)
            BeginTextCommandDisplayText('BEG_LABEL')
            AddTextComponentSubstringPlayerName(text.content)
            EndTextCommandDisplayText(_x,_y)
            -- if rect.draw then
            --     DrawRect(_x , _y + 0.0150, 0.040 + ((string.len(text.content)) / 370) * scale, 0.03 * scale, rect.rgba[1], rect.rgba[2], rect.rgba[3], rect.rgba[4])
            -- end
        end
    end
end

function Delete3DText(id)
    if (textArray[1] ~= nil) then
        for key, obj in pairs(textArray) do
            if (obj.id == id) then
                table.remove(textArray, key)
                return
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if (textArray[1] ~= nil) then
            local showingCounter = 0
            for key, obj in pairs(textArray) do
                if Vdist2(GetEntityCoords(PlayerPedId(), false), obj.parameters.xyz.x, obj.parameters.xyz.y, obj.parameters.xyz.z) < obj.parameters.radius then
                    textArray[key].show = true
                    showingCounter = showingCounter + 1
                else
                    textArray[key].show = false
                end
            end
            if (showingCounter == 0) then
                anyTextShowing = false
            else 
                anyTextShowing = true
            end
        end
    end
end)

Citizen.CreateThread(function()
    local p = nil
    local fov = nil

    AddTextEntry('BEG_LABEL', '~a~')
    while true do
        Citizen.Wait(1)
        if (anyTextShowing) then
            p = GetGameplayCamCoords()
            fov = (1 / GetGameplayCamFov()) * 75
            for key, obj in pairs(textArray) do
                if obj.show then
                    local onScreen, _x, _y = World3dToScreen2d(obj.parameters.xyz.x, obj.parameters.xyz.y, obj.parameters.xyz.z)
                    if onScreen then
                        local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, obj.parameters.xyz.x, obj.parameters.xyz.y, obj.parameters.xyz.z, 1)
                        local scale = (1 / distance) * obj.parameters.perspectiveScale
                        scale = scale * fov * obj.parameters.text.scaleMultiplier
                        SetTextScale(0.0, scale)
                        SetTextFont(obj.parameters.text.font)
                        SetTextProportional(true)
                        SetTextColour(obj.parameters.text.rgba[1], obj.parameters.text.rgba[2], obj.parameters.text.rgba[3], obj.parameters.text.rgba[4])
                        --SetTextDropshadow(0, 0, 0, 0, 255)
                        --SetTextEdge(2, 0, 0, 0, 150)
                        if obj.parameters.text.textOutline then
                            SetTextOutline()
                        end
                        SetTextCentre(true)
                        BeginTextCommandDisplayText('BEG_LABEL')
                        AddTextComponentSubstringPlayerName(obj.parameters.text.content)
                        EndTextCommandDisplayText(_x,_y)
                        -- if obj.parameters.rect.draw then
                        --     DrawRect(_x , _y + 0.025, 0.040 + ((string.len(obj.parameters.text.content)) / 135) * scale, 0.07 * scale, obj.parameters.rect.rgba[1], obj.parameters.rect.rgba[2], obj.parameters.rect.rgba[3], obj.parameters.rect.rgba[4])
                        -- end
                    end
                end
            end
        end
    end
end)
