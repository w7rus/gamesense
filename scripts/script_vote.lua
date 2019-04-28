local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_color_picker = ui.new_color_picker
local ui_set_callback = ui.set_callback
local ui_get = ui.get
local ui_set = ui.set
local ui_reference = ui.reference

local math_min = math.min
local math_max = math.max
local math_floor = math.floor

local renderer_text = renderer.text
local renderer_rectangle = renderer.rectangle
local renderer_line = renderer.line
local renderer_measure_text = renderer.measure_text

local globals_curtime = globals.curtime
local globals_tickcount = globals.tickcount
local globals_mapname = globals.mapname

local client_exec = client.exec
local client_screen_size = client.screen_size
local client_userid_to_entindex = client.userid_to_entindex
local client_set_cvar = client.set_cvar
local client_delay_call = client.delay_call
local client_set_event_callback = client.set_event_callback

local entity_get_local_player = entity.get_local_player

local string_format = string.format
local table_concat = table.concat


-- [About]--------------------------------------------------------------------------------------------------------------
-- Made by w7rus (Astolfo)
-- Credits: duk [https://gamesense.pub/forums/viewtopic.php?id=10838]
--          spongyguy [https://gamesense.pub/forums/viewtopic.php?id=8383]

-- [Configuration] --------------------------------------------------------------- [Description] -----------------------

local b_autovote_enable                                     = ui_new_checkbox("Misc", "Miscellaneous", "Autovote")

local i_autovote_relPosX                                    = ui_new_slider("Misc", "Miscellaneous", "Autovote > Indicator PosX", 0, 100, 50, true, "%", 1)
local i_autovote_relPosY                                    = ui_new_slider("Misc", "Miscellaneous", "Autovote > Indicator PosY", 0, 100, 95, true, "%", 1)
local i_autovote_relSizeX                                   = ui_new_slider("Misc", "Miscellaneous", "Autovote > Indicator SizeX", 0, 100, 100, true, "%", 1)
local i_autovote_relSizeY                                   = ui_new_slider("Misc", "Miscellaneous", "Autovote > Indicator SizeY", 0, 100, 3, true, "%", 1)

local str_autovote_voteName                                 = "👌 \nAn error has occured!\nPress F2 to continue..."

local b_autovote_keepVoteName                               = ui_new_checkbox("Misc", "Miscellaneous", "Autovote > Keep vote name")

local b_autovote_debug                                      = ui_new_checkbox("Misc", "Miscellaneous", "Autovote > Debug")

-- ["Do not edit below this line"] -------------------------------------------------------------------------------------
-- [Calculated configuration] ------------------------------------------------------------------------------------------

local entIndex_localEntCCSPlayer                            = entity_get_local_player()
local entIndex_localEntCCSPlayer_pName                      = cvar.name:get_string()
local i_autovote_scrWidth,
      i_autovote_scrHeight                                  = client_screen_size()
local i_autovote_eVoteCast_tSwapTeams_timeStamp             = 0
local i_autovote_eVoteCast_tChangeLevel_timeStamp           = 0
local i_autovote_eVoteCast_tAny_timeStamp                   = 0
local i_autovote_eVoteOptions_tickStamp                     = 0
local b_autovote_tSwapTeams_cooldown                        = false
local b_autovote_tChangeLevel_cooldown                      = false
local b_autovote_tAny_cooldown                              = false
local i_autovote_voteCast                                   = 0
local t_autovote_voteOptions                                = {}
local str_autovote_eVoteCast_voteName                       = ""
local ref_autovote_stealPlayerName                          = ui_reference("Misc", "Miscellaneous", "Steal player name")

-- [Functions] ---------------------------------------------------------------------------------------------------------

function func_autovote_eVoteOptions(event)
    if not ui_get(b_autovote_enable) then
        return
    end

    t_autovote_voteOptions[0] = event.option1
    t_autovote_voteOptions[1] = event.option2
    t_autovote_voteOptions[2] = event.option3
    t_autovote_voteOptions[3] = event.option4
    t_autovote_voteOptions[4] = event.option5
    i_autovote_eVoteOptions_tickStamp = globals_tickcount()
end

function func_autovote_eVoteCast_delayCall2()
    if not ui_get(b_autovote_keepVoteName) then
        client_set_cvar("name", entIndex_localEntCCSPlayer_pName)
    end
end

function func_autovote_eVoteCast_delayCall1()
    local str_serverMap = globals_mapname()

    if  i_autovote_voteCast == 0 and
        b_autovote_tChangeLevel_cooldown == false and
        b_autovote_tAny_cooldown == false then

            client_exec("callvote changelevel " .. str_serverMap)
            i_autovote_voteCast = 1
            b_autovote_tChangeLevel_cooldown = true
            b_autovote_tAny_cooldown = true
            i_autovote_eVoteCast_tChangeLevel_timeStamp = globals_curtime()
            i_autovote_eVoteCast_tAny_timeStamp = globals_curtime()
    end
    if  i_autovote_voteCast == 1 and
        b_autovote_tSwapTeams_cooldown == false and
        b_autovote_tAny_cooldown == false then

            client_exec("callvote swapteams")
            i_autovote_voteCast = 0
            b_autovote_tSwapTeams_cooldown = true
            b_autovote_tAny_cooldown = true
            i_autovote_eVoteCast_tSwapTeams_timeStamp = globals_curtime()
            i_autovote_eVoteCast_tAny_timeStamp = globals_curtime()
    end

    client_delay_call(0.25, func_autovote_eVoteCast_delayCall2)
end

function func_autovote_eVoteCast(event)
    if not ui_get(b_autovote_enable) then
        return
    end

    entIndex_serverEntCCSPlayer = event.entityid
    if entIndex_serverEntCCSPlayer == nil then
        return
    end

    if b_autovote_tAny_cooldown == false then
        if entIndex_serverEntCCSPlayer == entIndex_localEntCCSPlayer then
            if i_autovote_eVoteOptions_tickStamp == globals_tickcount() then
                if t_autovote_voteOptions[event.vote_option] == "No" then
                    str_autovote_eVoteCast_voteName = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" .. str_autovote_voteName .. "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

                    client_set_cvar("name", str_autovote_eVoteCast_voteName)

                    client_delay_call(0.25, func_autovote_eVoteCast_delayCall1)
                end
            end
        end
    end
end

function func_autovote_ePlayerConnectFull(event)
    entIndex_localEntCCSPlayer = entity_get_local_player()
    if client_userid_to_entindex(event.userid) == entIndex_localEntCCSPlayer then
        entIndex_localEntCCSPlayer_pName = cvar.name:get_string()
        i_autovote_eVoteCast_tSwapTeams_timeStamp = 0
        i_autovote_eVoteCast_tChangeLevel_timeStamp = 0
        i_autovote_eVoteCast_tAny_timeStamp = 0
        i_autovote_eVoteOptions_tickStamp = 0
        b_autovote_tSwapTeams_cooldown = false
        b_autovote_tChangeLevel_cooldown = false
        b_autovote_tAny_cooldown = false
        i_autovote_voteCast = 0
        t_autovote_voteOptions = {}
        func_autovote_setup()
    end
end

function func_autovote_eDraw()
    if not ui_get(b_autovote_enable) then
        return
    end

    local i_autovote_eDraw_timeStamp = globals_curtime()
    local i_autovote_eVoteCast_tSwapTeams_cooldown = 0
    local i_autovote_eVoteCast_tChangeLevel_cooldown = 0

    local i_autovote_eVoteCast_tSwapTeams_duration = i_autovote_eDraw_timeStamp - i_autovote_eVoteCast_tSwapTeams_timeStamp
    local i_autovote_eVoteCast_tChangeLevel_duration = i_autovote_eDraw_timeStamp - i_autovote_eVoteCast_tChangeLevel_timeStamp
    local i_autovote_eVoteCast_tAny_duration = 0
    local i_autovote_eVoteCast_tAny_limit = 0

    if b_autovote_tSwapTeams_cooldown then
        if i_autovote_eVoteCast_tSwapTeams_duration > 300 then
            b_autovote_tSwapTeams_cooldown = false
        end

        i_autovote_eVoteCast_tSwapTeams_cooldown = i_autovote_eVoteCast_tSwapTeams_duration
    else
        i_autovote_eVoteCast_tSwapTeams_cooldown = 0
    end

    if b_autovote_tChangeLevel_cooldown then
        if i_autovote_eVoteCast_tChangeLevel_duration > 300 then
            b_autovote_tChangeLevel_cooldown = false
        end

        i_autovote_eVoteCast_tChangeLevel_cooldown = i_autovote_eVoteCast_tChangeLevel_duration
    else
        i_autovote_eVoteCast_tChangeLevel_cooldown = 0
    end

    if b_autovote_tAny_cooldown then
        if math_min(i_autovote_eVoteCast_tSwapTeams_cooldown, i_autovote_eVoteCast_tChangeLevel_cooldown) < 90 and (b_autovote_tSwapTeams_cooldown == false or b_autovote_tChangeLevel_cooldown == false) then
            i_autovote_eVoteCast_tAny_duration = i_autovote_eDraw_timeStamp - i_autovote_eVoteCast_tAny_timeStamp

            if i_autovote_eVoteCast_tAny_duration > 90 then
                b_autovote_tAny_cooldown = false
            end
        else
            i_autovote_eVoteCast_tAny_duration = math_max(i_autovote_eVoteCast_tSwapTeams_cooldown, i_autovote_eVoteCast_tChangeLevel_cooldown)
        end
    else
        i_autovote_eVoteCast_tAny_duration = 0
    end

    if b_autovote_tAny_cooldown then
        if b_autovote_tSwapTeams_cooldown or b_autovote_tChangeLevel_cooldown then
            i_autovote_eVoteCast_tAny_limit = 90
        end
        if b_autovote_tSwapTeams_cooldown and b_autovote_tChangeLevel_cooldown then
            i_autovote_eVoteCast_tAny_limit = 300
        end
    else
        i_autovote_eVoteCast_tAny_limit = 0
    end

    if ui_get(b_autovote_debug) then
        local x, y = 8, 256
        renderer_text(x, y + 8 * 0, 255, 255, 255, 255, nil, 0, "globals_curtime: " .. string_format("%.2f", i_autovote_eDraw_timeStamp))
        renderer_text(x, y + 8 * 1, 255, 255, 255, 255, nil, 0, "SwapTeams_timeStamp: " .. string_format("%.2f", i_autovote_eVoteCast_tSwapTeams_timeStamp))
        renderer_text(x, y + 8 * 2, 255, 255, 255, 255, nil, 0, "ChangeLevel_timeStamp: " .. string_format("%.2f", i_autovote_eVoteCast_tChangeLevel_timeStamp))
        renderer_text(x, y + 8 * 3, 255, 255, 255, 255, nil, 0, "Any_timeStamp: " .. string_format("%.2f", i_autovote_eVoteCast_tAny_timeStamp))

        renderer_text(x, y + 8 * 5, 255, 255, 255, 255, nil, 0, "SwapTeams_duration: " .. string_format("%.2f", i_autovote_eVoteCast_tSwapTeams_duration))
        renderer_text(x, y + 8 * 6, 255, 255, 255, 255, nil, 0, "ChangeLevel_duration: " .. string_format("%.2f", i_autovote_eVoteCast_tChangeLevel_duration))
        renderer_text(x, y + 8 * 7, 255, 255, 255, 255, nil, 0, "Any_duration: " .. string_format("%.2f", i_autovote_eVoteCast_tAny_duration))
        renderer_text(x, y + 8 * 8, 255, 255, 255, 255, nil, 0, "Any_limit: " .. string_format("%.2f", i_autovote_eVoteCast_tAny_limit))
        renderer_text(x, y + 8 * 9, 255, 255, 255, 255, nil, 0, "Any_overall: " .. string_format("%.2f", i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration))

        renderer_text(x, y + 8 * 11, 255, 255, 255, 255, nil, 0, "SwapTeams_cooldown: " .. tostring(b_autovote_tSwapTeams_cooldown))
        renderer_text(x, y + 8 * 12, 255, 255, 255, 255, nil, 0, "ChangeLevel_cooldown: " .. tostring(b_autovote_tChangeLevel_cooldown))
        renderer_text(x, y + 8 * 13, 255, 255, 255, 255, nil, 0, "Any_cooldown: " .. tostring(b_autovote_tAny_cooldown))

        renderer_text(x, y + 8 * 14, 255, 255, 255, 255, nil, 0, "voteOptions: " .. table_concat(t_autovote_voteOptions, ", "))
    end

    local i_autovote_absPosX = math_floor(i_autovote_scrWidth * (ui_get(i_autovote_relPosX) / 100))
    local i_autovote_absPosY = math_floor(i_autovote_scrHeight * (ui_get(i_autovote_relPosY) / 100))
    local i_autovote_absSizeX = math_floor(i_autovote_scrWidth * (ui_get(i_autovote_relSizeX) / 100))
    local i_autovote_absSizeY = math_floor(i_autovote_scrHeight * (ui_get(i_autovote_relSizeY) / 100))

    if ui.is_menu_open() then
        renderer_rectangle((i_autovote_absPosX - i_autovote_absSizeX / 2), i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absSizeX, i_autovote_absSizeY, 0, 0, 0, 127)

        renderer_text(i_autovote_absPosX - i_autovote_absSizeX / 2 + 64, i_autovote_absPosY, 255, 255, 255, 255, "c", 0, string_format("%d", i_autovote_absSizeX) .. "x" .. string_format("%d", i_autovote_absSizeY) .. " [" .. string_format("%d", i_autovote_absPosX) .. ", " .. string_format("%d", i_autovote_absPosY) .. "]")
        
        renderer.line(i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absPosX - i_autovote_absSizeX / 2 + 3, i_autovote_absPosY - i_autovote_absSizeY / 2, 255, 255, 255, 255)
        renderer.line(i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2 + 3, 255, 255, 255, 255)

        renderer.line(i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2, i_autovote_absPosX - i_autovote_absSizeX / 2 + 3, i_autovote_absPosY + i_autovote_absSizeY / 2, 255, 255, 255, 255)
        renderer.line(i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2, i_autovote_absPosX - i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2 - 3, 255, 255, 255, 255)

        renderer.line(i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absPosX + i_autovote_absSizeX / 2 - 3, i_autovote_absPosY - i_autovote_absSizeY / 2, 255, 255, 255, 255)
        renderer.line(i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY - i_autovote_absSizeY / 2 + 3, 255, 255, 255, 255)

        renderer.line(i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2, i_autovote_absPosX + i_autovote_absSizeX / 2 - 3, i_autovote_absPosY + i_autovote_absSizeY / 2, 255, 255, 255, 255)
        renderer.line(i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2, i_autovote_absPosX + i_autovote_absSizeX / 2, i_autovote_absPosY + i_autovote_absSizeY / 2 - 3, 255, 255, 255, 255)
    end

    if i_autovote_eVoteCast_tAny_duration > 0 then
        renderer_rectangle((i_autovote_absPosX - i_autovote_absSizeX / 2) + (i_autovote_absSizeX / 2) * (1 - ((i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration) / (i_autovote_eVoteCast_tAny_limit))), i_autovote_absPosY - i_autovote_absSizeY / 2, i_autovote_absSizeX * ((i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration) / (i_autovote_eVoteCast_tAny_limit)), i_autovote_absSizeY, 0, 0, 0, 127)
        renderer_text(i_autovote_absPosX, i_autovote_absPosY, 255, 255, 255, 255, "c", 0, "Autovote cooldown: " .. string_format("%.2f", i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration))
    else
        if b_autovote_tSwapTeams_cooldown or b_autovote_tChangeLevel_cooldown then
            renderer_text(i_autovote_absPosX, i_autovote_absPosY, 0, 255, 0, 255, "c", 0, "x1 Autovote available!")
        else
            renderer_text(i_autovote_absPosX, i_autovote_absPosY, 0, 255, 0, 255, "c", 0, "x2 Autovote available!")
        end
    end

    if i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration > 0 and i_autovote_eVoteCast_tAny_limit - i_autovote_eVoteCast_tAny_duration < 1 and ui_get(b_autovote_keepVoteName) then
        client_set_cvar("name", entIndex_localEntCCSPlayer_pName)
    end
end

function func_autovote_setup_delayCall()
    client_set_cvar("name", entIndex_localEntCCSPlayer_pName)
end

function func_autovote_setup()
    if ui_get(b_autovote_enable) then
        client_exec("clear")
        ui_set(ref_autovote_stealPlayerName, true)
        client_set_cvar("name", "\n\xAD\xAD\xAD\xAD")
        client_exec("status")
        client_delay_call(0.5, func_autovote_setup_delayCall)
    else
        client_set_cvar("name", entIndex_localEntCCSPlayer_pName)
    end
end

func_autovote_setup()
ui_set_callback(b_autovote_enable, func_autovote_setup)

client_set_event_callback("player_connect_full", func_autovote_ePlayerConnectFull)
client_set_event_callback("vote_cast", func_autovote_eVoteCast)
client_set_event_callback("vote_options", func_autovote_eVoteOptions)
client_set_event_callback("paint", func_autovote_eDraw)

-- [End of file] -------------------------------------------------------------------------------------------------------