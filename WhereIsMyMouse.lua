local addonName = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

local cursorIcon = nil
-- local circleFrame = nil
local mouseMoveTime = 0
local lastMouseX, lastMouseY = 0, 0
local shakeThreshold = 120 -- Adjust this value to change the sensitivity of the shake detection.
local lasts = 0.75
local lastTime = lasts

-- local function updateFramePosition(self, elapsed)
--     updateCursorPosition()
-- end

local function updateCursorPosition()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    cursorIcon:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
    -- circleFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end

local function onMouseMove(self, elapsed)
    local mouseX, mouseY = GetCursorPosition()
    local distance = math.sqrt((mouseX - lastMouseX)^2 + (mouseY - lastMouseY)^2)

    if distance > shakeThreshold then
        -- DEFAULT_CHAT_FRAME:AddMessage("Distance:  "..distance)
        -- DEFAULT_CHAT_FRAME:AddMessage("Threshold: "..shakeThreshold)
        mouseMoveTime = mouseMoveTime + elapsed
        -- DEFAULT_CHAT_FRAME:AddMessage("Time:      "..mouseMoveTime)
    else
        mouseMoveTime = 0
    end

    if mouseMoveTime > 0.01 then
        local newSize = cursorIcon:GetWidth() * 1.5
        cursorIcon:SetSize(newSize, newSize)
        cursorIcon:Show()
        -- local newSize = circleFrame:GetWidth() * 1.1
        -- circleFrame:SetSize(newSize + 10, newSize + 10)
    elseif lastTime > elapsed then
        lastTime = lastTime - elapsed
    else
        cursorIcon:Hide()
        cursorIcon:SetSize(32, 32)
        lastTime = lasts
        -- circleFrame:SetSize(42, 42)
    end

    lastMouseX, lastMouseY = mouseX, mouseY
    updateCursorPosition()
end

local function onEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            cursorIcon = CreateFrame("Frame", nil, UIParent)
            cursorIcon:SetSize(32, 32)
            -- cursorIcon:SetPoint("TOPLEFT", 0, 0)
            cursorIcon:SetPoint("CENTER", 0, 0)

            local texture = cursorIcon:CreateTexture(nil, "OVERLAY")
            texture:SetAllPoints()
            -- texture:SetTexture("Interface\\AddOns\\"..addonName.."\\Circle.tga")
            texture:SetTexture("Interface\\AddOns\\"..addonName.."\\Cursor.tga")

            -- circleFrame = CreateFrame("Frame", nil, UIParent)
            -- circleFrame:SetSize(42, 42)
            -- circleFrame:SetPoint("CENTER", 0, 0)

            -- local circleTexture = circleFrame:CreateTexture(nil, "OVERLAY")
            -- --local circleTexture = circleFrame:CreateTexture(nil, "BACKGROUND")
            -- circleTexture:SetAllPoints()
            -- circleTexture:SetTexture("Interface\\AddOns\\"..addonName.."\\Circle.tga")

            frame:SetScript("OnUpdate", onMouseMove)
        end
    end
end

frame:SetScript("OnEvent", onEvent)
-- frame:SetScript("OnUpdate", updateFramePosition)
