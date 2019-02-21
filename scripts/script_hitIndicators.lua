-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by w7rus (Astolfo)

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_hitindicators_enable                                  = 1                 -- <0/1> Register callbacks and allow listeners (Script master switch)

    b_hitindicators_ePlayerHurt                             = 1                 -- <0/1> Filter playerHurt event
    b_hitindicators_ePlayerDeath                            = 1                 -- <0/1> Filter playerDeath event
    b_hitindicators_ePlayerDeath_kHeadshot                  = 1                 -- <0/1> Filter playerDeath event headshot int
    b_hitindicators_ePlayerDeath_kPenetrated                = 1                 -- <0/1> Filter playerDeath event penetrated int

    i_hitindicators_drawStartAlpha                          = 255               -- <0 ... 255> Start alpha of hit indicators
    i_hitindicators_drawEndAlpha                            = 0                 -- <0 ... 255> End alpha of hit indicators
    f_hitindicators_drawLifetime                            = 1                 -- <0.0 ... +inf> Lifetime of hit indicators for constant framerate //TODO: Rework the method of fading ((curTime - eventTime)/lifetime as percentage)
    f_hitindicators_drawScreenX                             = 0.5               -- <0.0 ... 1.0> Screen horizontal offset (in %)
    f_hitindicators_drawScreenY                             = 0.5               -- <0.0 ... 1.0> Screen vertical offset (in %)
    i_hitindicators_drawSizeX                               = 32                -- <0 ... min(client.screen_size().x)> Screen vertical offset (in px.)
    i_hitindicators_drawSizeY                               = 32                -- <0 ... min(client.screen_size().y)> Screen vertical offset (in px.)

    i_hitindicators_ePlayerHurt_drawColorRed                = 255.0             -- <0 ... 255> playerHurt event hit indicators color channel red
    i_hitindicators_ePlayerHurt_drawColorGreen              = 255.0             -- <0 ... 255> playerHurt event hit indicators color channel green
    i_hitindicators_ePlayerHurt_drawColorBlue               = 255.0             -- <0 ... 255> playerHurt event hit indicators color channel blue
    i_hitindicators_ePlayerHurt_drawColorAlpha              = 255.0             -- <0 ... 255> playerHurt event hit indicators color channel alpha
    i_hitindicators_ePlayerDeath_drawColorRed               = 0.0               -- <0 ... 255> playerDeath event hit indicators color channel red
    i_hitindicators_ePlayerDeath_drawColorGreen             = 255.0             -- <0 ... 255> playerDeath event hit indicators color channel green
    i_hitindicators_ePlayerDeath_drawColorBlue              = 127.0             -- <0 ... 255> playerDeath event hit indicators color channel blue
    i_hitindicators_ePlayerDeath_drawColorAlpha             = 255.0             -- <0 ... 255> playerDeath event hit indicators color channel alpha
    i_hitindicators_ePlayerDeath_kHeadshot_drawColorRed     = 255.0             -- <0 ... 255> playerDeath event headshot int hit indicators color channel red
    i_hitindicators_ePlayerDeath_kHeadshot_drawColorGreen   = 255.0             -- <0 ... 255> playerDeath event headshot int hit indicators color channel green
    i_hitindicators_ePlayerDeath_kHeadshot_drawColorBlue    = 0.0               -- <0 ... 255> playerDeath event headshot int hit indicators color channel blue
    i_hitindicators_ePlayerDeath_kHeadshot_drawColorAlpha   = 255.0             -- <0 ... 255> playerDeath event headshot int hit indicators color channel alpha
    i_hitindicators_ePlayerDeath_kPenetrated_drawColorRed   = 0.0               -- <0 ... 255> playerDeath event penetrated int hit indicators color channel red
    i_hitindicators_ePlayerDeath_kPenetrated_drawColorGreen = 175.0             -- <0 ... 255> playerDeath event penetrated int hit indicators color channel green
    i_hitindicators_ePlayerDeath_kPenetrated_drawColorBlue  = 255.0             -- <0 ... 255> playerDeath event penetrated int hit indicators color channel blue
    i_hitindicators_ePlayerDeath_kPenetrated_drawColorAlpha = 255.0             -- <0 ... 255> playerDeath event penetrated int hit indicators color channel alpha

    b_hitindicators_drawDebug                               = 0                 -- <0/1> Draw debug info

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer                              = entity.get_local_player()
    f_hitindicators_drawRangeAlpha                          = i_hitindicators_drawStartAlpha - i_hitindicators_drawEndAlpha
    f_hitindicators_drawCurrentAlpha                        = nil
    f_hitindicators_e_timestamp                             = nil
    i_hitindicators_e_index                                 = nil
    i_hitindicators_ePlayerHurt_index                       = 0
    i_hitindicators_ePlayerDeath_index                      = 0
    i_hitindicators_ePlayerDeath_kHeadshot_index            = 0
    i_hitindicators_ePlayerDeath_kPenetrated_index          = 0
    i_hitindicators_ePlayerHurt_kHealth                     = nil
    i_hitindicators_ePlayerHurt_kDmg_Health                 = nil
    i_hitindicators_drawScreenWidth,
    i_hitindicators_drawScreenHeight                        = client.screen_size()

    t_hitindicators_stats                                   = {}
    t_hitindicators_stats["fps_01"]                         = 0.0
    t_hitindicators_stats["fps_02"]                         = 0.0

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

function func_hitindicators_draw()
    local i_hitindicators_drawPosX = math.floor(i_hitindicators_drawScreenWidth * f_hitindicators_drawScreenX)
    local i_hitindicators_drawPosY = math.floor(i_hitindicators_drawScreenHeight * f_hitindicators_drawScreenY)

    t_hitindicators_stats["fps_01"] = (0.9 * t_hitindicators_stats["fps_01"] + (1.0 - 0.9) * globals.absoluteframetime())
    t_hitindicators_stats["fps_02"] = math.floor(1.0 / t_hitindicators_stats["fps_01"] + 0.5);

    if i_hitindicators_e_index and f_hitindicators_e_timestamp then
        local f_hitindicators_e_timestampDelta = globals.curtime() - f_hitindicators_e_timestamp

        if f_hitindicators_e_timestampDelta < f_hitindicators_drawLifetime then
            f_hitindicators_drawCurrentAlpha = math.floor(f_hitindicators_drawCurrentAlpha - (f_hitindicators_drawRangeAlpha / (f_hitindicators_drawLifetime / (t_hitindicators_stats["fps_01"] * 0.85))))

            if b_hitindicators_drawDebug == 1 then
                renderer.text(0, 0 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, string.format("playerHurt: %u", bit.band(i_hitindicators_e_index, 1)))
                renderer.text(0, 8 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, string.format("playerDeath: %u", bit.band(i_hitindicators_e_index, 2)))
                renderer.text(0, 16 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, string.format("playerDeath_kHeadshot: %u", bit.band(i_hitindicators_e_index, 4)))
                renderer.text(0, 24 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, string.format("playerDeath_kPenetrated: %u", bit.band(i_hitindicators_e_index, 8)))
                renderer.text(8, 32 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, "Approximate Lifetime [FPS]: " .. string.format("%.3f", f_hitindicators_drawLifetime / t_hitindicators_stats["fps_01"]))
                renderer.text(8, 40 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, "Alpha substraction per frame: " .. string.format("%.3f", f_hitindicators_drawRangeAlpha / (f_hitindicators_drawLifetime / (t_hitindicators_stats["fps_01"] * 0.85))))
                renderer.text(8, 48 + i_hitindicators_drawPosY, 255, 255, 255, 255, nil, 0, "Alpha: " .. string.format("%3d", f_hitindicators_drawCurrentAlpha))
            end

            if i_hitindicators_drawStartAlpha > i_hitindicators_drawEndAlpha and f_hitindicators_drawCurrentAlpha <= i_hitindicators_drawStartAlpha and f_hitindicators_drawCurrentAlpha >= i_hitindicators_drawEndAlpha then
                --
                --
                --  eventPlayerHurt
                --
                --
                if bit.band(i_hitindicators_e_index, 1) == 1 then
                    local i_hitindicators_ePlayerHurt_strSizeX, i_hitindicators_ePlayerHurt_strSizeY = renderer.measure_text("+", string.format("%d (%d)", i_hitindicators_ePlayerHurt_kDmg_Health, i_hitindicators_ePlayerHurt_kHealth))

                    renderer.text(i_hitindicators_drawPosX + i_hitindicators_drawSizeX, i_hitindicators_drawPosY - i_hitindicators_ePlayerHurt_strSizeY / 2, i_hitindicators_ePlayerHurt_drawColorRed, i_hitindicators_ePlayerHurt_drawColorGreen, i_hitindicators_ePlayerHurt_drawColorBlue, math.floor(f_hitindicators_drawCurrentAlpha * i_hitindicators_ePlayerHurt_drawColorAlpha / 255), "+", 0, string.format("%d [%d]", i_hitindicators_ePlayerHurt_kDmg_Health, i_hitindicators_ePlayerHurt_kHealth))
                end
                --
                --
                --  eventPlayerDeath
                --
                --
                if bit.band(i_hitindicators_e_index, 2) == 2 then
                    local i_hitindicators_ePlayerDeath_strSizeX, i_hitindicators_ePlayerDeath_strSizeY = renderer.measure_text("+", "K")
                    
                    renderer.text(i_hitindicators_drawPosX - i_hitindicators_drawSizeX - i_hitindicators_ePlayerDeath_strSizeX, i_hitindicators_drawPosY - i_hitindicators_ePlayerDeath_strSizeY / 2, i_hitindicators_ePlayerDeath_drawColorRed, i_hitindicators_ePlayerDeath_drawColorGreen, i_hitindicators_ePlayerDeath_drawColorBlue, math.floor(f_hitindicators_drawCurrentAlpha * i_hitindicators_ePlayerDeath_drawColorAlpha / 255), "+", 0, "K")
                end
                --
                --
                --  eventPlayerDeath.headshot
                --
                --
                if bit.band(i_hitindicators_e_index, 4) == 4 then
                    local i_hitindicators_ePlayerDeath_kHeadshot_strSizeX, i_hitindicators_ePlayerDeath_kHeadshot_strSizeY = renderer.measure_text("+", "H")
                    renderer.text(i_hitindicators_drawPosX - i_hitindicators_drawSizeX - i_hitindicators_ePlayerDeath_kHeadshot_strSizeX * 2, i_hitindicators_drawPosY - i_hitindicators_ePlayerDeath_kHeadshot_strSizeY / 2, i_hitindicators_ePlayerDeath_kHeadshot_drawColorRed, i_hitindicators_ePlayerDeath_kHeadshot_drawColorGreen, i_hitindicators_ePlayerDeath_kHeadshot_drawColorBlue, math.floor(f_hitindicators_drawCurrentAlpha * i_hitindicators_ePlayerDeath_kHeadshot_drawColorAlpha / 255), "+", 0, "H")
                end
                --
                --
                --  eventPlayerDeath.penetrated
                --
                --
                if bit.band(i_hitindicators_e_index, 8) == 8 then
                    local i_hitindicators_ePlayerDeath_kPenetrated_strSizeX, i_hitindicators_ePlayerDeath_kPenetrated_strSizeY = renderer.measure_text("+", "H")
                    renderer.text(i_hitindicators_drawPosX - i_hitindicators_drawSizeX - i_hitindicators_ePlayerDeath_kPenetrated_strSizeX * 3, i_hitindicators_drawPosY - i_hitindicators_ePlayerDeath_kPenetrated_strSizeY / 2, i_hitindicators_ePlayerDeath_kPenetrated_drawColorRed, i_hitindicators_ePlayerDeath_kPenetrated_drawColorGreen, i_hitindicators_ePlayerDeath_kPenetrated_drawColorBlue, math.floor(f_hitindicators_drawCurrentAlpha * i_hitindicators_ePlayerDeath_kPenetrated_drawColorAlpha / 255), "+", 0, "P")
                end
            end
        else
            f_hitindicators_e_timestamp = nil
            i_hitindicators_e_index = nil
            i_hitindicators_ePlayerHurt_index = 0
            i_hitindicators_ePlayerHurt_index = 0
            i_hitindicators_ePlayerDeath_kHeadshot_index = 0
            f_hitindicators_drawCurrentAlpha = i_hitindicators_drawStartAlpha
        end
    end
end

function func_hitindicators_event_playerHurt(event)
    local entIndex_serverEntCCSPlayer01 = client.userid_to_entindex(event.userid)
    local entIndex_serverEntCCSPlayer02 = client.userid_to_entindex(event.attacker)
    --
    --
    --  eventPlayerHurt
    --
    --
    if b_hitindicators_ePlayerHurt == 1 then
        -- Do stuff
        if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
            i_hitindicators_ePlayerHurt_index = 1
            i_hitindicators_ePlayerDeath_index = 0
            i_hitindicators_ePlayerDeath_kHeadshot_index = 0
            i_hitindicators_ePlayerDeath_kPenetrated_index = 0
            i_hitindicators_e_index = i_hitindicators_ePlayerHurt_index + i_hitindicators_ePlayerDeath_index + i_hitindicators_ePlayerDeath_kHeadshot_index + i_hitindicators_ePlayerDeath_kPenetrated_index

            f_hitindicators_e_timestamp = globals.curtime()
            f_hitindicators_drawCurrentAlpha = i_hitindicators_drawStartAlpha

            i_hitindicators_ePlayerHurt_kHealth = event.health
            i_hitindicators_ePlayerHurt_kDmg_Health = event.dmg_health
        end
    end
end

function func_hitindicators_event_playerDeath(event)
    local entIndex_serverEntCCSPlayer01 = client.userid_to_entindex(event.userid)
    local entIndex_serverEntCCSPlayer02 = client.userid_to_entindex(event.attacker)
    local b_hitindicators_ePlayerDeath_kHeadshot_key = event.headshot
    local i_hitindicators_ePlayerDeath_kPenetrated_key = event.penetrated
    --
    --
    --  eventPlayerDeath
    --
    --
    if b_hitindicators_ePlayerDeath == 1 then
        -- Do stuff
        if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
            i_hitindicators_ePlayerDeath_index = 2
            i_hitindicators_e_index = i_hitindicators_ePlayerHurt_index + i_hitindicators_ePlayerDeath_index + i_hitindicators_ePlayerDeath_kHeadshot_index + i_hitindicators_ePlayerDeath_kPenetrated_index

            f_hitindicators_e_timestamp = globals.curtime()
            f_hitindicators_drawCurrentAlpha = i_hitindicators_drawStartAlpha
        end
    end
    --
    --
    --  eventPlayerDeath.headshot
    --
    --
    if b_hitindicators_ePlayerDeath_kHeadshot == 1 then
        if b_hitindicators_ePlayerDeath_kHeadshot_key == true then
            -- Do stuff
            if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                i_hitindicators_ePlayerDeath_kHeadshot_index = 4
                i_hitindicators_e_index = i_hitindicators_ePlayerHurt_index + i_hitindicators_ePlayerDeath_index + i_hitindicators_ePlayerDeath_kHeadshot_index + i_hitindicators_ePlayerDeath_kPenetrated_index

                f_hitindicators_e_timestamp = globals.curtime()
                f_hitindicators_drawCurrentAlpha = i_hitindicators_drawStartAlpha
            end
        else
            i_hitindicators_ePlayerDeath_kHeadshot_index = 0
        end
    end
    --
    --
    --  eventPlayerDeath.penetrated
    --
    --
    if b_hitindicators_ePlayerDeath_kPenetrated == 1 then
        if i_hitindicators_ePlayerDeath_kPenetrated_key > 0 then
            -- Do stuff
            if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                i_hitindicators_ePlayerDeath_kPenetrated_index = 8
                i_hitindicators_e_index = i_hitindicators_ePlayerHurt_index + i_hitindicators_ePlayerDeath_index + i_hitindicators_ePlayerDeath_kHeadshot_index + i_hitindicators_ePlayerDeath_kPenetrated_index

                f_hitindicators_e_timestamp = globals.curtime()
                f_hitindicators_drawCurrentAlpha = i_hitindicators_drawStartAlpha
            end
        else
            i_hitindicators_ePlayerDeath_kPenetrated_index = 0
        end
    end
end

function func_hitindicators_event_playerConnectFull(event)
    entIndex_localEntCCSPlayer = entity.get_local_player();
end

if b_hitindicators_enable == 1 then
    client.set_event_callback("paint", func_hitindicators_draw)
    client.set_event_callback("player_hurt", func_hitindicators_event_playerHurt)
    client.set_event_callback("player_death", func_hitindicators_event_playerDeath)
    client.set_event_callback("player_connect_full", func_hitindicators_event_playerConnectFull)
end

-- [End of file] -------------------------------------------------------------------------------------------------------------------------------------------------