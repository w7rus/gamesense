require("lib_gamesense")
local imageLib = require( "lib_image" )
local icons_indicators = imageLib.load(require("imagepack_battlefield"))
-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by: w7rus (Astolfo)
-- Credits: sapphyrus [lib_image]
--          Aviarita [lib_gamesense]

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_indicators_enable                                    = true

    b_indicators_highLatency                               = true
    b_indicators_latencyVariation                          = true
    b_indicators_lowfps                                    = true
    b_indicators_packetLoss                                = true
    b_indicators_refreshRate                               = true
    b_indicators_serverPerformance                         = true

    i_indicators_highLatency_limitLevel1                   = 80
    i_indicators_highLatency_limitLevel2                   = 95
    i_indicators_highLatency_limitLevel3                   = 110

    i_indicators_latencyVariation_limitLevel1              = 10
    i_indicators_latencyVariation_limitLevel2              = 20
    i_indicators_latencyVariation_limitLevel3              = 30
    i_indicators_latencyVariation_history                  = 10

    i_indicators_lowfps_limitLevel1                        = 75
    i_indicators_lowfps_limitLevel2                        = 60
    i_indicators_lowfps_limitLevel3                        = 30

    i_indicators_packetLoss_limitLevel1                    = 1
    i_indicators_packetLoss_limitLevel2                    = 10
    i_indicators_packetLoss_limitLevel3                    = 50

    i_indicators_refreshRate_hz                            = 120

    i_indicators_serverPerformance_limitLevel1             = 15
    i_indicators_serverPerformance_limitLevel2             = 50
    i_indicators_serverPerformance_limitLevel3             = 100

    t_indicators_highLatency_colorLevel1                    = {255, 255, 255, 255}
    t_indicators_highLatency_colorLevel2                    = {235, 143, 6, 255}
    t_indicators_highLatency_colorLevel3                    = {225, 66, 11, 255}
    t_indicators_highLatency_colorLevelKeep                 = {225, 255, 255, 32}

    t_indicators_latencyVariation_colorLevel1               = {255, 255, 255, 255}
    t_indicators_latencyVariation_colorLevel2               = {235, 143, 6, 255}
    t_indicators_latencyVariation_colorLevel3               = {225, 66, 11, 255}
    t_indicators_latencyVariation_colorLevelKeep            = {225, 255, 255, 32}

    t_indicators_lowfps_colorLevel1                         = {255, 255, 255, 255}
    t_indicators_lowfps_colorLevel2                         = {235, 143, 6, 255}
    t_indicators_lowfps_colorLevel3                         = {225, 66, 11, 255}
    t_indicators_lowfps_colorLevelKeep                      = {225, 255, 255, 32}

    t_indicators_packetLoss_colorLevel1                     = {255, 255, 255, 255}
    t_indicators_packetLoss_colorLevel2                     = {235, 143, 6, 255}
    t_indicators_packetLoss_colorLevel3                     = {225, 66, 11, 255}
    t_indicators_packetLoss_colorLevelKeep                  = {225, 255, 255, 32}

    t_indicators_refreshRate_colorLevel1                    = {255, 255, 255, 255}
    t_indicators_refreshRate_colorLevel2                    = {235, 143, 6, 255}
    t_indicators_refreshRate_colorLevel3                    = {225, 66, 11, 255}
    t_indicators_refreshRate_colorLevelKeep                 = {225, 255, 255, 32}

    t_indicators_serverPerformance_colorLevel1              = {255, 255, 255, 255}
    t_indicators_serverPerformance_colorLevel2              = {235, 143, 6, 255}
    t_indicators_serverPerformance_colorLevel3              = {225, 66, 11, 255}
    t_indicators_serverPerformance_colorLevelKeep           = {225, 255, 255, 32}

    i_indicators_keep                                       = 5

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer                             = entity.get_local_player()
    i_esp_drawScreenWidth,
    i_esp_drawScreenHeight                                 = client.screen_size()
    g_tickRate                                             = 1 / globals.tickinterval()
    i_indicators_refreshRate_limitLevel1                   = g_tickRate
    i_indicators_refreshRate_limitLevel2                   = g_tickRate / 2
    i_indicators_refreshRate_limitLevel3                   = g_tickRate / 4
    g_frameRate                                            = 0.0
    t_statusIndicators_latencyVariation_history            = {}
    i_statusIndicators_latencyVariation_history_tickStamp  = 0
    i_statusIndicators_highLatency_tickStamp               = 0
    i_statusIndicators_latencyVariation_tickStamp          = 0
    i_statusIndicators_lowfps_tickStamp                    = 0
    i_statusIndicators_packetLoss_tickStamp                = 0
    i_statusIndicators_refreshRate_tickStamp               = 0
    i_statusIndicators_serverPerformance_tickStamp         = 0

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

local get_abs_fps = function()
    g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * globals.absoluteframetime()
    return math.floor((1.0 / g_frameRate) + 0.5)
end

local set_globals = function()
    g_tickRate = 1 / globals.tickinterval()
    i_indicators_refreshRate_limitLevel1 = g_tickRate
    i_indicators_refreshRate_limitLevel2 = g_tickRate / 2
    i_indicators_refreshRate_limitLevel3 = g_tickRate / 4
    i_statusIndicators_highLatency_tickStamp = 0
    i_statusIndicators_latencyVariation_tickStamp = 0
    i_statusIndicators_lowfps_tickStamp = 0
    i_statusIndicators_packetLoss_tickStamp = 0
    i_statusIndicators_refreshRate_tickStamp = 0
    i_statusIndicators_serverPerformance_tickStamp = 0
end

local func_indicators_draw = function()
    local i_indicators_drawPosX, i_indicators_drawPosY = math.floor(i_esp_drawScreenWidth * 0.9), math.floor(i_esp_drawScreenHeight * 0.1)

    local i_statusIndicators_current_tickStamp = globals.tickcount()

    if b_indicators_highLatency then
        local color = {}
        local obj_localEntCCSPlayer = Playerresource(entIndex_localEntCCSPlayer)
        local latency = obj_localEntCCSPlayer:get_ping()
        if latency <= i_indicators_highLatency_limitLevel1 then
            color = t_indicators_highLatency_colorLevelKeep
        end
        if latency > i_indicators_highLatency_limitLevel1 then
            color = t_indicators_highLatency_colorLevel1
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latency > i_indicators_highLatency_limitLevel2 then
            color = t_indicators_highLatency_colorLevel2
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latency > i_indicators_highLatency_limitLevel3 then
            color = t_indicators_highLatency_colorLevel3
            i_statusIndicators_highLatency_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        latency > i_indicators_highLatency_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_highLatency_tickStamp + i_indicators_keep * g_tickRate
        then
            -- renderer.text(i_indicators_drawPosX + 72, i_indicators_drawPosY + 32, 255, 255, 255, 255, nil, 0, latency)
            icons_indicators["high_latency"]:draw(i_indicators_drawPosX, i_indicators_drawPosY, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_indicators_latencyVariation then
        local color = {}
        local obj_localEntCCSPlayer = Playerresource(entIndex_localEntCCSPlayer)
        local latency = obj_localEntCCSPlayer:get_ping()
        if i_statusIndicators_current_tickStamp - i_statusIndicators_latencyVariation_history_tickStamp >= g_tickRate then
            table.insert(t_statusIndicators_latencyVariation_history, latency)
            i_statusIndicators_latencyVariation_history_tickStamp = i_statusIndicators_current_tickStamp
        end
        if #t_statusIndicators_latencyVariation_history > i_indicators_latencyVariation_history then
            table.remove(t_statusIndicators_latencyVariation_history, 1)
        end
        latencyMax = math.max(unpack(t_statusIndicators_latencyVariation_history))
        latencyMin = math.min(unpack(t_statusIndicators_latencyVariation_history))
        latencyDelta = latencyMax - latencyMin
        if latencyDelta <= i_indicators_latencyVariation_limitLevel1 then
            color = t_indicators_latencyVariation_colorLevelKeep
        end
        if latencyDelta > i_indicators_latencyVariation_limitLevel1 then
            color = t_indicators_latencyVariation_colorLevel1
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latencyDelta > i_indicators_latencyVariation_limitLevel2 then
            color = t_indicators_latencyVariation_colorLevel2
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if latencyDelta > i_indicators_latencyVariation_limitLevel3 then
            color = t_indicators_latencyVariation_colorLevel3
            i_statusIndicators_latencyVariation_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        latencyDelta > i_indicators_latencyVariation_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_latencyVariation_tickStamp + i_indicators_keep * g_tickRate
        then
            -- renderer.text(i_indicators_drawPosX + 72, i_indicators_drawPosY + 72 * 2 + 32, 255, 255, 255, 255, nil, 0, latencyDelta)
            icons_indicators["latency_variation"]:draw(i_indicators_drawPosX, i_indicators_drawPosY + 72 * 2, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_indicators_lowfps then
        local color = {}
        local abs_fps = get_abs_fps()

        if abs_fps >= i_indicators_lowfps_limitLevel3 then
            color = t_indicators_lowfps_colorLevelKeep
        end
        if abs_fps < i_indicators_lowfps_limitLevel1 then
            color = t_indicators_lowfps_colorLevel1
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end
        if abs_fps < i_indicators_lowfps_limitLevel2 then
            color = t_indicators_lowfps_colorLevel2
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end
        if abs_fps < i_indicators_lowfps_limitLevel3 then
            color = t_indicators_lowfps_colorLevel3
            i_statusIndicators_lowfps_tickStamp = i_statusIndicators_current_tickStamp
        end

        if
        abs_fps < i_indicators_lowfps_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_lowfps_tickStamp + i_indicators_keep * g_tickRate
        then
            -- renderer.text(i_indicators_drawPosX + 72, i_indicators_drawPosY + 72 * 3 + 32, 255, 255, 255, 255, nil, 0, abs_fps)
            icons_indicators["low_fps"]:draw(i_indicators_drawPosX, i_indicators_drawPosY + 72 * 3, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_indicators_packetLoss then     

    end
    if b_indicators_refreshRate then
        local color = {}
        local refreshrate = math.min(i_indicators_refreshRate_hz, get_abs_fps())
        if refreshrate >= i_indicators_refreshRate_limitLevel1 then
            color = t_indicators_refreshRate_colorLevelKeep
        end
        if refreshrate < i_indicators_refreshRate_limitLevel1 then
            color = t_indicators_refreshRate_colorLevel1
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if refreshrate < i_indicators_refreshRate_limitLevel2 then
            color = t_indicators_refreshRate_colorLevel2
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if refreshrate < i_indicators_refreshRate_limitLevel3 then
            color = t_indicators_refreshRate_colorLevel3
            i_statusIndicators_refreshRate_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        refreshrate < i_indicators_refreshRate_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_refreshRate_tickStamp + i_indicators_keep * g_tickRate
        then
            -- renderer.text(i_indicators_drawPosX + 72, i_indicators_drawPosY + 72 * 5 + 32, 255, 255, 255, 255, nil, 0, refreshrate)
            icons_indicators["refresh_rate"]:draw(i_indicators_drawPosX, i_indicators_drawPosY + 72 * 5, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
    if b_indicators_serverPerformance then
        local clientperformance = globals.absoluteframetime() * 1000
        local color = {}
        if clientperformance <= i_indicators_serverPerformance_limitLevel1 then
            color = t_indicators_serverPerformance_colorLevelKeep
        end
        if clientperformance > i_indicators_serverPerformance_limitLevel1 then
            color = t_indicators_serverPerformance_colorLevel1
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if clientperformance > i_indicators_serverPerformance_limitLevel2 then
            color = t_indicators_serverPerformance_colorLevel2
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if clientperformance > i_indicators_serverPerformance_limitLevel3 then
            color = t_indicators_serverPerformance_colorLevel3
            i_statusIndicators_serverPerformance_tickStamp = i_statusIndicators_current_tickStamp
        end
        if
        clientperformance > i_indicators_serverPerformance_limitLevel1
        or
        i_statusIndicators_current_tickStamp < i_statusIndicators_serverPerformance_tickStamp + i_indicators_keep * g_tickRate
        then
            -- renderer.text(i_indicators_drawPosX + 72, i_indicators_drawPosY + 72 * 6 + 32, 255, 255, 255, 255, nil, 0, string.format("%.2f", clientperformance))
            icons_indicators["server_performance"]:draw(i_indicators_drawPosX, i_indicators_drawPosY + 72 * 6, 64, 64, color[1], color[2], color[3], color[4])
        end
    end
end

if b_indicators_enable then
    client.set_event_callback("paint", func_indicators_draw)
    client.set_event_callback("player_connect_full", set_globals)
end