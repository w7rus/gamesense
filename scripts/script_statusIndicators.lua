require("lib_gamesense")
local imageLib = require( "lib_image" )
local icons_statusIndicators = imageLib.load(require("imagepack_battlefield"))
-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by w7rus (Astolfo)

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_statusIndicators_enable                               = true              -- <true/false> Master Switch

    b_statusIndicators_highLatency                          = true              -- <true/false> Show high latency indicator
    b_statusIndicators_latencyVariation                     = true              -- <true/false> Show latency variation indicator
    b_statusIndicators_lowfps                               = true              -- <true/false> Show low FPS indicator
    b_statusIndicators_packetLoss                           = true              -- <true/false> Show packet loss indicator (Unavailable, no way to get data)
    b_statusIndicators_refreshRate                          = true              -- <true/false> Show refresh rate indicator
    b_statusIndicators_serverPerformance                    = true              -- <true/false> Show server performance indicator (Unavailable, shows client performance)

    i_statusIndicators_highLatency_limitLevel1              = 80                -- <0 ... 1000> Show indicator in color of Level 1 when exceeding the set limit (in msec.)
    i_statusIndicators_highLatency_limitLevel2              = 95                -- <0 ... 1000> Show indicator in color of Level 2 when exceeding the set limit (in msec.)
    i_statusIndicators_highLatency_limitLevel3              = 110               -- <0 ... 1000> Show indicator in color of Level 3 when exceeding the set limit (in msec.)

    i_statusIndicators_latencyVariation_limitLevel1         = 10                -- <0 ... 1000> Show indicator in color of Level 1 when exceeding the set limit (in msec.)
    i_statusIndicators_latencyVariation_limitLevel2         = 20                -- <0 ... 1000> Show indicator in color of Level 2 when exceeding the set limit (in msec.)
    i_statusIndicators_latencyVariation_limitLevel3         = 30                -- <0 ... 1000> Show indicator in color of Level 3 when exceeding the set limit (in msec.)
    i_statusIndicators_latencyVariation_history             = 10                -- <0 ... +inf> Amount of latency values to track for latency delta

    i_statusIndicators_lowfps_limitLevel1                   = 75                -- <1 ... +inf> Amount of frames to show indicator in color of Level 1 when exceeding the set limit
    i_statusIndicators_lowfps_limitLevel2                   = 60                -- <1 ... +inf> Amount of frames to show indicator in color of Level 2 when exceeding the set limit
    i_statusIndicators_lowfps_limitLevel3                   = 30                -- <1 ... +inf> Amount of frames to show indicator in color of Level 3 when exceeding the set limit

    f_statusIndicators_packetLoss_limitLevel1               = 0.01              -- <0.(0)1 ... 100.0> Show indicator in color of Level 1 when exceeding the set limit (in %)
    f_statusIndicators_packetLoss_limitLevel2               = 0.1               -- <0.(0)1 ... 100.0> Show indicator in color of Level 2 when exceeding the set limit (in %)
    f_statusIndicators_packetLoss_limitLevel3               = 0.5               -- <0.(0)1 ... 100.0> Show indicator in color of Level 3 when exceeding the set limit (in %)

    i_statusIndicators_refreshRate_hz                       = 120               -- <1 ... +inf> Set your screen refresh rate (in Hz.)

    f_statusIndicators_serverPerformance_limitLevel1        = 15                -- <0.0 ... +inf> Show indicator in color of Level 1 when exceeding the set limit
    f_statusIndicators_serverPerformance_limitLevel2        = 50                -- <0.0 ... +inf> Show indicator in color of Level 2 when exceeding the set limit
    f_statusIndicators_serverPerformance_limitLevel3        = 100               -- <0.0 ... +inf> Show indicator in color of Level 3 when exceeding the set limit

    t_statusIndicators_highLatency_colorLevel1              = {255, 255, 255, 255}
    t_statusIndicators_highLatency_colorLevel2              = {235, 143, 6, 255}
    t_statusIndicators_highLatency_colorLevel3              = {225, 66, 11, 255}
    t_statusIndicators_highLatency_colorLevelKeep           = {225, 255, 255, 32}

    t_statusIndicators_latencyVariation_colorLevel1         = {255, 255, 255, 255}
    t_statusIndicators_latencyVariation_colorLevel2         = {235, 143, 6, 255}
    t_statusIndicators_latencyVariation_colorLevel3         = {225, 66, 11, 255}
    t_statusIndicators_latencyVariation_colorLevelKeep      = {225, 255, 255, 32}

    t_statusIndicators_lowfps_colorLevel1                   = {255, 255, 255, 255}
    t_statusIndicators_lowfps_colorLevel2                   = {235, 143, 6, 255}
    t_statusIndicators_lowfps_colorLevel3                   = {225, 66, 11, 255}
    t_statusIndicators_lowfps_colorLevelKeep                = {225, 255, 255, 32}

    t_statusIndicators_packetLoss_colorLevel1               = {255, 255, 255, 255}
    t_statusIndicators_packetLoss_colorLevel2               = {235, 143, 6, 255}
    t_statusIndicators_packetLoss_colorLevel3               = {225, 66, 11, 255}
    t_statusIndicators_packetLoss_colorLevelKeep            = {225, 255, 255, 32}

    t_statusIndicators_refreshRate_colorLevel1              = {255, 255, 255, 255}
    t_statusIndicators_refreshRate_colorLevel2              = {235, 143, 6, 255}
    t_statusIndicators_refreshRate_colorLevel3              = {225, 66, 11, 255}
    t_statusIndicators_refreshRate_colorLevelKeep           = {225, 255, 255, 32}

    t_statusIndicators_serverPerformance_colorLevel1        = {255, 255, 255, 255}
    t_statusIndicators_serverPerformance_colorLevel2        = {235, 143, 6, 255}
    t_statusIndicators_serverPerformance_colorLevel3        = {225, 66, 11, 255}
    t_statusIndicators_serverPerformance_colorLevelKeep     = {225, 255, 255, 32}

    f_statusIndicators_keep                                 = 5.0               -- <0.0 ... +inf> Keep drawing indicator in color of "Level Keep" after normalization for given amount of time (in sec.)

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer                              = entity.get_local_player()
    i_esp_drawScreenWidth,
    i_esp_drawScreenHeight                                  = client.screen_size()
    g_tickRate                                              = 1 / globals.tickinterval()
    i_statusIndicators_refreshRate_limitLevel1              = g_tickRate
    i_statusIndicators_refreshRate_limitLevel2              = g_tickRate / 2
    i_statusIndicators_refreshRate_limitLevel3              = g_tickRate / 4
    g_frameRate                                             = 0.0
    t_statusIndicators_latencyVariation_history             = {}
    i_statusIndicators_latencyVariation_history_tickStamp   = 0
    i_statusIndicators_highLatency_tickStamp                = 0
    i_statusIndicators_latencyVariation_tickStamp           = 0
    i_statusIndicators_lowfps_tickStamp                     = 0
    i_statusIndicators_packetLoss_tickStamp                 = 0
    i_statusIndicators_refreshRate_tickStamp                = 0
    i_statusIndicators_serverPerformance_tickStamp          = 0

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

local function get_abs_fps()
    g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * globals.absoluteframetime()
    return math.floor((1.0 / g_frameRate) + 0.5)
end

local function set_globals()
    g_tickRate = 1 / globals.tickinterval()
    i_statusIndicators_refreshRate_limitLevel1 = g_tickRate
    i_statusIndicators_refreshRate_limitLevel2 = g_tickRate / 2
    i_statusIndicators_refreshRate_limitLevel3 = g_tickRate / 4
    i_statusIndicators_highLatency_tickStamp = 0
    i_statusIndicators_latencyVariation_tickStamp = 0
    i_statusIndicators_lowfps_tickStamp = 0
    i_statusIndicators_packetLoss_tickStamp = 0
    i_statusIndicators_refreshRate_tickStamp = 0
    i_statusIndicators_serverPerformance_tickStamp = 0
end

local function func_statusIndicators_draw()
    local i_statusIndicators_drawPosX, i_statusIndicators_drawPosY = math.floor(i_esp_drawScreenWidth * 0.9), math.floor(i_esp_drawScreenHeight * 0.1)

    local i_statusIndicators_current_tickStamp = globals.tickcount()

    if b_statusIndicators_highLatency then
        local color = {}
        local obj_localEntCCSPlayer = Playerresource(entIndex_localEntCCSPlayer)
        local latency = obj_localEntCCSPlayer:get_ping()
        if latency <= i_statusIndicators_highLatency_limitLevel1 then
            color = t_statusIndicators_highLatency_colorLevelKeep
        end
        if latency > i_statusIndicators_highLatency_limitLevel1 then
            color = t_statusIndicators_highLatency_colorLevel1
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latency > i_statusIndicators_highLatency_limitLevel2 then
            color = t_statusIndicators_highLatency_colorLevel2
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latency > i_statusIndicators_highLatency_limitLevel3 then
            color = t_statusIndicators_highLatency_colorLevel3
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        latency > i_statusIndicators_highLatency_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_highLatency_tickStamp + f_statusIndicators_keep * g_tickRate
        then
            -- renderer.text(i_statusIndicators_drawPosX + 72, i_statusIndicators_drawPosY + 32, 255, 255, 255, 255, nil, 0, latency)
            icons_statusIndicators["high_latency"]:draw(i_statusIndicators_drawPosX, i_statusIndicators_drawPosY, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_statusIndicators_latencyVariation then
        local color = {}
        local obj_localEntCCSPlayer = Playerresource(entIndex_localEntCCSPlayer)
        local latency = obj_localEntCCSPlayer:get_ping()
        if i_statusIndicators_current_tickStamp - i_statusIndicators_latencyVariation_history_tickStamp >= g_tickRate then
            table.insert(t_statusIndicators_latencyVariation_history, latency)
            i_statusIndicators_latencyVariation_history_tickStamp = i_statusIndicators_current_tickStamp
        end
        if #t_statusIndicators_latencyVariation_history > i_statusIndicators_latencyVariation_history then
            table.remove(t_statusIndicators_latencyVariation_history, 1)
        end
        latencyMax = math.max(unpack(t_statusIndicators_latencyVariation_history))
        latencyMin = math.min(unpack(t_statusIndicators_latencyVariation_history))
        latencyDelta = latencyMax - latencyMin
        if latencyDelta <= i_statusIndicators_latencyVariation_limitLevel1 then
            color = t_statusIndicators_latencyVariation_colorLevelKeep
        end
        if latencyDelta > i_statusIndicators_latencyVariation_limitLevel1 then
            color = t_statusIndicators_latencyVariation_colorLevel1
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latencyDelta > i_statusIndicators_latencyVariation_limitLevel2 then
            color = t_statusIndicators_latencyVariation_colorLevel2
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latencyDelta > i_statusIndicators_latencyVariation_limitLevel3 then
            color = t_statusIndicators_latencyVariation_colorLevel3
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        latencyDelta > i_statusIndicators_latencyVariation_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_latencyVariation_tickStamp + f_statusIndicators_keep * g_tickRate
        then
            -- renderer.text(i_statusIndicators_drawPosX + 72, i_statusIndicators_drawPosY + 72 * 2 + 32, 255, 255, 255, 255, nil, 0, latencyDelta)
            icons_statusIndicators["latency_variation"]:draw(i_statusIndicators_drawPosX, i_statusIndicators_drawPosY + 72 * 2, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_statusIndicators_lowfps then
        local color = {}
        local abs_fps = get_abs_fps()

        if abs_fps >= i_statusIndicators_lowfps_limitLevel3 then
            color = t_statusIndicators_lowfps_colorLevelKeep
        end
        if abs_fps < i_statusIndicators_lowfps_limitLevel1 then
            color = t_statusIndicators_lowfps_colorLevel1
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end
        if abs_fps < i_statusIndicators_lowfps_limitLevel2 then
            color = t_statusIndicators_lowfps_colorLevel2
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end
        if abs_fps < i_statusIndicators_lowfps_limitLevel3 then
            color = t_statusIndicators_lowfps_colorLevel3
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end

        if
        abs_fps < i_statusIndicators_lowfps_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_lowfps_tickStamp + f_statusIndicators_keep * g_tickRate
        then
            -- renderer.text(i_statusIndicators_drawPosX + 72, i_statusIndicators_drawPosY + 72 * 3 + 32, 255, 255, 255, 255, nil, 0, abs_fps)
            icons_statusIndicators["low_fps"]:draw(i_statusIndicators_drawPosX, i_statusIndicators_drawPosY + 72 * 3, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_statusIndicators_packetLoss then     

    end
    if b_statusIndicators_refreshRate then
        local color = {}
        local refreshrate = math.min(i_statusIndicators_refreshRate_hz, get_abs_fps())
        if refreshrate >= i_statusIndicators_refreshRate_limitLevel1 then
            color = t_statusIndicators_refreshRate_colorLevelKeep
        end
        if refreshrate < i_statusIndicators_refreshRate_limitLevel1 then
            color = t_statusIndicators_refreshRate_colorLevel1
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if refreshrate < i_statusIndicators_refreshRate_limitLevel2 then
            color = t_statusIndicators_refreshRate_colorLevel2
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if refreshrate < i_statusIndicators_refreshRate_limitLevel3 then
            color = t_statusIndicators_refreshRate_colorLevel3
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        refreshrate < i_statusIndicators_refreshRate_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_refreshRate_tickStamp + f_statusIndicators_keep * g_tickRate
        then
            -- renderer.text(i_statusIndicators_drawPosX + 72, i_statusIndicators_drawPosY + 72 * 5 + 32, 255, 255, 255, 255, nil, 0, refreshrate)
            icons_statusIndicators["refresh_rate"]:draw(i_statusIndicators_drawPosX, i_statusIndicators_drawPosY + 72 * 5, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_statusIndicators_serverPerformance then
        local clientperformance = globals.absoluteframetime() * 1000
        local color = {}
        if clientperformance <= f_statusIndicators_serverPerformance_limitLevel1 then
            color = t_statusIndicators_serverPerformance_colorLevelKeep
        end
        if clientperformance > f_statusIndicators_serverPerformance_limitLevel1 then
            color = t_statusIndicators_serverPerformance_colorLevel1
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if clientperformance > f_statusIndicators_serverPerformance_limitLevel2 then
            color = t_statusIndicators_serverPerformance_colorLevel2
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if clientperformance > f_statusIndicators_serverPerformance_limitLevel3 then
            color = t_statusIndicators_serverPerformance_colorLevel3
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        clientperformance > f_statusIndicators_serverPerformance_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_serverPerformance_tickStamp + f_statusIndicators_keep * g_tickRate
        then
            -- renderer.text(i_statusIndicators_drawPosX + 72, i_statusIndicators_drawPosY + 72 * 6 + 32, 255, 255, 255, 255, nil, 0, string.format("%.2f", clientperformance))
            icons_statusIndicators["server_performance"]:draw(i_statusIndicators_drawPosX, i_statusIndicators_drawPosY + 72 * 6, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
end

if b_statusIndicators_enable then
    client.set_event_callback("paint", func_statusIndicators_draw)
    client.set_event_callback("player_connect_full", set_globals)
end

-- [End of file] -------------------------------------------------------------------------------------------------------------------------------------------------