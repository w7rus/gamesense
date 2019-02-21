-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by w7rus (Astolfo)

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_hitsounds_enable                                      = 1                 -- <true/false> Master Switch

    b_hitsounds_ePlayerHurt                                 = 1                 -- <0/1> Filter playerHurt event
    b_hitsounds_ePlayerDeath                                = 1                 -- <0/1> Filter playerDeath event
    b_hitsounds_ePlayerDeath_kHeadshot                      = 1                 -- <0/1> Filter playerDeath event headshot int
    s_hitsounds_ePlayerHurt_snd        = "rush_charge_disarm_beep_01_wave_0_0_0"-- <string playerHurt event sound file
    s_hitsounds_ePlayerDeath_snd      = "obliteration_bomb_beep_long_wave_0_0_0"-- <string> playerDeath event sound file
    s_hitsounds_ePlayerDeath_kHeadshot_snd = "ui_battledash_notification_wave_0_0_0"-- <string> playerDeath event headshot int sound file
    f_hitsounds_ePlayerHurt_sndVol                          = 1.0               -- <0.0 ... 1.0> playerHurt event sound volume
    f_hitsounds_ePlayerDeath_sndVol                         = 1.0               -- <0.0 ... 1.0> playerDeath event sound volume
    f_hitsounds_ePlayerDeath_kHeadshot_sndVol               = 1.0               -- <0.0 ... 1.0> playerDeath event headshot int sound volume

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer        = entity.get_local_player()

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

function func_hitsounds_event_playerHurt(event)
    local entIndex_serverEntCCSPlayer01 = client.userid_to_entindex(event.userid)
    local entIndex_serverEntCCSPlayer02 = client.userid_to_entindex(event.attacker)
    --
    --
    --  eventPlayerHurt
    --
    --
    if b_hitsounds_ePlayerHurt == 1 then
        -- Do stuff
        if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
            cvar.playvol:invoke_callback(s_hitsounds_ePlayerHurt_snd, f_hitsounds_ePlayerHurt_sndVol);
        end
    end
end

function func_hitsounds_event_playerDeath(event)
    local entIndex_serverEntCCSPlayer01 = client.userid_to_entindex(event.userid)
    local entIndex_serverEntCCSPlayer02 = client.userid_to_entindex(event.attacker)
    local b_hitindicators_ePlayerDeath_kHeadshot_key = event.headshot
    --
    --
    --  eventPlayerDeath
    --
    --
    if b_hitsounds_ePlayerDeath == 1 then
        -- Do stuff
        if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
            cvar.playvol:invoke_callback(s_hitsounds_ePlayerDeath_snd, f_hitsounds_ePlayerDeath_sndVol);
        end
    end
    --
    --
    --  eventPlayerDeath.headshot
    --
    --
    if b_hitsounds_ePlayerDeath_kHeadshot == 1 then
        if b_hitindicators_ePlayerDeath_kHeadshot_key == true then
            -- Do stuff
            if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                cvar.playvol:invoke_callback(s_hitsounds_ePlayerDeath_kHeadshot_snd, f_hitsounds_ePlayerDeath_kHeadshot_sndVol);
            end
        end
    end
end

function func_hitindicators_event_playerConnectFull(event)
    entIndex_localEntCCSPlayer = entity.get_local_player();
end

if b_hitsounds_enable then
    client.set_event_callback("player_hurt", func_hitsounds_event_playerHurt)
    client.set_event_callback("player_death", func_hitsounds_event_playerDeath)
    client.set_event_callback("player_connect_full", func_hitindicators_event_playerConnectFull)
end

-- [End of file] -------------------------------------------------------------------------------------------------------------------------------------------------