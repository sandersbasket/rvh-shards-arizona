script_name('RVH-FAM')
script_author('sanders')
local imgui = require("imgui")
local sW, sH = getScreenResolution()
local encoding = require ("encoding")
local inicfg = require("inicfg")
local asd = 0
local activated = false
local window = imgui.ImBool(false)
encoding.default = "CP1251"
u8 = encoding.UTF8
local mainIni = inicfg.load({ -- CFG
    config = {
        enableNew = false,
        FontFlag = 5,
        FontSize = 10
    }
}, "rvh-fam")
local enable = imgui.ImBool(mainIni.config.enableNew)
local fSize = imgui.ImInt(mainIni.config.FontSize)
local fFlag = imgui.ImInt(mainIni.config.FontFlag)

local status = inicfg.load(mainIni, 'rvh-fam.ini')
if not doesFileExist('moonloader/config/rvh-fam.ini') then inicfg.save(mainIni, 'rvh-fam.ini') end

function main()
    while not isSampAvailable() do wait(100) end
    local font = renderCreateFont("Arial", fSize.v, fFlag.v)
    sampAddChatMessage('{ff00ff}[RVH]{FFFFFF} Loaded! {f32f1f}BY SANDERS!', -1)
    lua_thread.create(function ()
        while true do
            wait(0)
            if activated then
                for _, v in pairs(getAllObjects()) do
                    if sampGetObjectSampIdByHandle(v) ~= -1 then
                        asd = sampGetObjectSampIdByHandle(v)
                    end
                    local model = getObjectModel(v)
                    if isObjectOnScreen(v) then
                        local model = getObjectModel(v)
                        if (enable.v and (model == 924)) then
                            local _, x, y, z = getObjectCoordinates(v)
                            local x1, y1 = convert3DCoordsToScreen(x,y,z)
                            local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                            local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                            local distance = string.format("%.0f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
                            if model == 924 then
                                nazvanie = 'Shards'
                                colorL = '0xFFff00ff'
                                colorT = '{ff00ff}'
                            end
                            renderDrawLine(x10, y10, x1, y1, 1.0, colorL)
                            renderFontDrawText(font, colorT..nazvanie..' {ffffff}['..distance..']', x1, y1-15, -1)
                        end
                    end
                end
            end
        end
    end)
    while true do
        wait(0)
        imgui.Process = window.v
        if isKeyDown(0x10) and isKeyJustPressed(0x48) then  
            window.v = not window.v 
        end
    end
end

function imgui.OnDrawFrame()
    if window.v then  
        imgui.SetNextWindowPos(imgui.ImVec2(sW / 2, sH / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 155), imgui.Cond.FirstUseEver)
        imgui.Begin('RVH | vk.com/sanders_scripts', window,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize)
            imgui.Text("Status:")
            imgui.SameLine()
            if activated then
                imgui.TextColored(imgui.ImVec4(0, 143, 0, 1), "ON")
            else
                imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), "OFF")
            end
            if imgui.Checkbox('Shards', enable) then  
                activated = not activated 
            end
            imgui.InputInt("Size", fSize)
            imgui.InputInt("Flag", fFlag)
            if imgui.Button('SAVE',imgui.ImVec2(285, 25)) then  
                mainIni.config.enableNew = enable.v 
                mainIni.config.FontSize = fSize.v  
                mainIni.config.FontFlag = fFlag.v 
                inicfg.save(mainIni, 'rvh-fam.ini')
                printStringNow('~p~SAVED~p~', 1000)
                addOneOffSound(0.0, 0.0, 0.0, 1138)
                printStringNow('~p~SAVED~p~', 1000)
            end
        imgui.End()
    end
end


function style()
    imgui.SwitchContext()
    local style  = imgui.GetStyle()
    local colors = style.Colors
    local clr    = imgui.Col
    local ImVec4 = imgui.ImVec4
  
      style.FrameRounding    = 4.0
      style.GrabRounding     = 4.0
  
      colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
      colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
      colors[clr.WindowBg]             = ImVec4(0.09, 0.09, 0.09, 0.94)
      colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
      colors[clr.Border]               = ImVec4(0.20, 0.20, 0.20, 0.50)
      colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg]              = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.FrameBgHovered]       = ImVec4(0.84, 0.66, 0.66, 0.40)
      colors[clr.FrameBgActive]        = ImVec4(0.84, 0.66, 0.66, 0.67)
      colors[clr.TitleBg]              = ImVec4(0.47, 0.22, 0.22, 0.67)
      colors[clr.TitleBgActive]        = ImVec4(0.47, 0.22, 0.22, 1.00)
      colors[clr.TitleBgCollapsed]     = ImVec4(0.47, 0.22, 0.22, 0.67)
      colors[clr.MenuBarBg]            = ImVec4(0.34, 0.16, 0.16, 1.00)
      colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.53)
      colors[clr.ScrollbarGrab]        = ImVec4(0.31, 0.31, 0.31, 1.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
      colors[clr.ScrollbarGrabActive]  = ImVec4(0.51, 0.51, 0.51, 1.00)
      colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
      colors[clr.SliderGrab]           = ImVec4(0.71, 0.39, 0.39, 1.00)
      colors[clr.SliderGrabActive]     = ImVec4(0.84, 0.66, 0.66, 1.00)
      colors[clr.Button]               = ImVec4(0.47, 0.22, 0.22, 0.65)
      colors[clr.ButtonHovered]        = ImVec4(0.71, 0.39, 0.39, 0.65)
      colors[clr.ButtonActive]         = ImVec4(0.20, 0.20, 0.20, 0.50)
      colors[clr.Header]               = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.HeaderHovered]        = ImVec4(0.84, 0.66, 0.66, 0.65)
      colors[clr.HeaderActive]         = ImVec4(0.84, 0.66, 0.66, 0.00)
      colors[clr.Separator]            = ImVec4(0.43, 0.43, 0.50, 0.50)
      colors[clr.SeparatorHovered]     = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.SeparatorActive]      = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.ResizeGrip]           = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.ResizeGripHovered]    = ImVec4(0.84, 0.66, 0.66, 0.66)
      colors[clr.ResizeGripActive]     = ImVec4(0.84, 0.66, 0.66, 0.66)
      colors[clr.CloseButton]          = ImVec4(0.41, 0.41, 0.41, 1.00)
      colors[clr.CloseButtonHovered]   = ImVec4(0.98, 0.39, 0.36, 1.00)
      colors[clr.CloseButtonActive]    = ImVec4(0.98, 0.39, 0.36, 1.00)
      colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
      colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
      colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end
style()