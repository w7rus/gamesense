-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by w7rus (Astolfo)

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_quakeSounds_enable                                    = true              -- <true/false> Master Switch

    t_quakeSounds_streakDataSet                             = require("data_quakeSet_ru")

    f_quakeSounds_keepComboStreak                           = 2.0               -- <0.0 ... 1.0> Keep combo streak this amount of seconds
    f_quakeSounds_masterVolume                              = 0.5               -- <0.0 ... 1.0> Master volume
    b_quakeSounds_stopSound                                 = true              -- <true/false> Stops previous sounds before playing a new one

    b_quakeSounds_resetStreakData_OnDeath                   = true              -- <true/false> Resets data on death
    b_quakeSounds_resetStreakData_OnRoundStart              = false             -- <true/false> Resets data on start of another round

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer                              = entity.get_local_player()
    g_tickRate                                              = 1 / globals.tickinterval()
    t_quakeSounds_StreakList                                = {}
    b_quakeSounds_playerDeath_count                         = 0

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

    local function table_contains_index(table, index)
        if table[index] ~= nil then
            return true
        end
        return false
    end

    local function table_contains_element(table, element)
        for i, value in pairs(table) do
            if i == element then
                return true
            end
        end
        return false
    end

    local function func_quakeSounds_streakData_reset()
        t_quakeSounds_StreakList = {
            ["i_quakeSounds_headshotStreak"]                    = 0,
            ["i_quakeSounds_headshotComboStreak"]               = 0,
            ["i_quakeSounds_headshotComboStreak_tickStamp"]     = 0,
            ["i_quakeSounds_killStreak"]                        = 0,
            ["i_quakeSounds_killComboStreak"]                   = 0,
            ["i_quakeSounds_killComboStreak_tickStamp"]         = 0,
            ["i_quakeSounds_grenadeStreak"]                     = 0,
            ["i_quakeSounds_grenadeComboStreak"]                = 0,
            ["i_quakeSounds_grenadeComboStreak_tickStamp"]      = 0,
            ["i_quakeSounds_knifeStreak"]                       = 0,
            ["i_quakeSounds_knifeComboStreak"]                  = 0,
            ["i_quakeSounds_knifeComboStreak_tickStamp"]        = 0
        }
    end

    local function func_quakeSounds_streakData_update(streakAlias, currentTick)
        if currentTick > t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak_tickStamp"] + f_quakeSounds_keepComboStreak * g_tickRate then
            t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak"] = 1;
            t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak_tickStamp"] = currentTick
        else
            t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak_tickStamp"] = currentTick
            t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak"] = t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak"] + 1;
        end
        t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "Streak"] = t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "Streak"] + 1;
        if string.find(streakAlias, "kill") == nil then
            t_quakeSounds_StreakList["i_quakeSounds_killStreak"] = t_quakeSounds_StreakList["i_quakeSounds_killStreak"] + 1;
        end
    end

    local function func_quakeSounds_streakSound_play(streakAlias)
        local streakCount = t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "Streak"]
        local streakComboCount = t_quakeSounds_StreakList["i_quakeSounds_" .. streakAlias .. "ComboStreak"]

        if streakComboCount > 1 then
            if table_contains_index(t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"], streakComboCount) then
                if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"][streakComboCount].sound, f_quakeSounds_masterVolume * t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"][streakComboCount].volume);
            elseif table_contains_index(t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"], 0) then
                if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"][0].sound, f_quakeSounds_masterVolume * t_quakeSounds_streakDataSet["snd_" .. streakAlias .. "Combo"][0].volume);
            end
        else
            if table_contains_index(t_quakeSounds_streakDataSet["snd_" .. streakAlias], streakCount) then
                if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_" .. streakAlias][streakCount].sound, f_quakeSounds_masterVolume * t_quakeSounds_streakDataSet["snd_" .. streakAlias][streakCount].volume);
            end
        end
    end

    local function func_quakeSounds_event_playerDeath(event)
        local entIndex_serverEntCCSPlayer01 = client.userid_to_entindex(event.userid)
        local entIndex_serverEntCCSPlayer02 = client.userid_to_entindex(event.attacker)
        local b_hitindicators_ePlayerDeath_kHeadshot_key = event.headshot
        local i_quakeSounds_current_tickStamp = globals.tickcount()
        b_quakeSounds_playerDeath_count = b_quakeSounds_playerDeath_count + 1

        if b_hitindicators_ePlayerDeath_kHeadshot_key == true then
            --
            --
            --  eventPlayerDeath.headshot
            --  Subblock for playerDeath events with headshot boolean equating true
            --
            if entIndex_serverEntCCSPlayer01 == entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 ~= entIndex_localEntCCSPlayer then
                --
                --
                --  eventPlayerDeath.headshot.killedByPlayer
                --  Subblock for playerDeath events with headshot boolean equating true AND localplayer gets killed by player
                --
                client.log("eventPlayerDeath.headshot.killedByPlayer")
                if b_quakeSounds_resetStreakData_OnDeath then
                    func_quakeSounds_streakData_reset()
                end
            end

            if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                --
                --
                --  eventPlayerDeath.headshot.hasKilled
                --  Subblock for playerDeath events with headshot boolean equating true AND localplayer scores a kill
                --
                if entity.get_prop(entIndex_serverEntCCSPlayer02, "m_iTeamNum") ~= entity.get_prop(entIndex_serverEntCCSPlayer01, "m_iTeamNum") then
                    --
                    --
                    --  eventPlayerDeath.headshot.hasKilled.enemy
                    --  Subblock for playerDeath events with headshot boolean equating true AND localplayer scores a kill AND player is in enemy team
                    --
                    if b_quakeSounds_playerDeath_count == 1 then
                        --
                        --
                        --  eventPlayerDeath.headshot.hasKilled.enemy.firstBlood
                        --  Subblock for playerDeath events with headshot boolean equating true AND localplayer scores a kill AND player is in enemy team AND it is first kill in a round
                        --
                        client.log("eventPlayerDeath.headshot.hasKilled.enemy.firstBlood")
                        if table_contains_element(t_quakeSounds_streakDataSet["snd_firstBlood"], "sound") then
                            func_quakeSounds_streakData_update("headshot", i_quakeSounds_current_tickStamp)
                            if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                            cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_firstBlood"].sound, f_quakeSounds_masterVolume);
                        end
                    else
                        --
                        --
                        --  eventPlayerDeath.headshot.hasKilled.enemy.normal
                        --  Subblock for playerDeath events with headshot boolean equating true AND localplayer scores a kill AND player is in enemy team AND it is not a first kill in a round
                        --
                        client.log("eventPlayerDeath.headshot.hasKilled.enemy.normal")
                        func_quakeSounds_streakData_update("headshot", i_quakeSounds_current_tickStamp)
                        func_quakeSounds_streakSound_play("headshot")
                    end

                else
                    --
                    --
                    --  eventPlayerDeath.headshot.hasKilled.ally
                    --  Subblock for playerDeath events with headshot boolean equating true AND localplayer scores a kill AND player is in ally team
                    --
                    client.log("eventPlayerDeath.headshot.hasKilled.ally")
                    if table_contains_element(t_quakeSounds_streakDataSet["snd_teamKill"], "sound") then
                        if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                        cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_teamKill"].sound, f_quakeSounds_masterVolume);
                        b_quakeSounds_playerDeath_count = b_quakeSounds_playerDeath_count - 1
                    end
                end
            end
        else
            --
            --
            --  eventPlayerDeath
            --  Subblock for playerDeath events
            --
            if entIndex_serverEntCCSPlayer01 == entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                --
                --
                --  eventPlayerDeath.selfkill
                --  Subblock for playerDeath events AND localplayer kills himself
                --
                client.log("eventPlayerDeath.selfkill")
                if table_contains_element(t_quakeSounds_streakDataSet["snd_selfKill"], "sound") then
                    if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                    cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_selfKill"].sound, f_quakeSounds_masterVolume);
                end
                if b_quakeSounds_resetStreakData_OnDeath then
                    func_quakeSounds_streakData_reset()
                end
            end

            if entIndex_serverEntCCSPlayer01 == entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 ~= entIndex_localEntCCSPlayer then
                --
                --
                --  eventPlayerDeath.killedByPlayer
                --  Subblock for playerDeath events AND localplayer gets killed by player
                --
                client.log("eventPlayerDeath.killedByPlayer")
                if b_quakeSounds_resetStreakData_OnDeath then
                    func_quakeSounds_streakData_reset()
                end
            end

            if entIndex_serverEntCCSPlayer01 ~= entIndex_localEntCCSPlayer and entIndex_serverEntCCSPlayer02 == entIndex_localEntCCSPlayer then
                --
                --
                --  eventPlayerDeath.hasKilled
                --  Subblock for playerDeath events AND localplayer scores a kill
                --
                if entity.get_prop(entIndex_serverEntCCSPlayer02, "m_iTeamNum") ~= entity.get_prop(entIndex_serverEntCCSPlayer01, "m_iTeamNum") then
                    --
                    --
                    --  eventPlayerDeath.hasKilled.enemy
                    --  Subblock for playerDeath events AND localplayer scores a kill AND player is in enemy team
                    --
                    if b_quakeSounds_playerDeath_count == 1 then
                        --
                        --
                        --  eventPlayerDeath.hasKilled.enemy.firstBlood
                        --  Subblock for playerDeath events AND localplayer scores a kill AND player is in enemy team AND it is first kill in a round
                        --
                        client.log("eventPlayerDeath.hasKilled.enemy.firstBlood")
                        if table_contains_element(t_quakeSounds_streakDataSet["snd_firstBlood"], "sound") then
                            func_quakeSounds_streakData_update("kill", i_quakeSounds_current_tickStamp)
                            if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                            cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_firstBlood"].sound, f_quakeSounds_masterVolume);
                        end
                    else
                        if string.find(event.weapon, "grenade") ~= nil or string.find(event.weapon, "flashbang") ~= nil then
                            --
                            --
                            --  eventPlayerDeath.hasKilled.enemy.grenade
                            --  Subblock for playerDeath events AND localplayer scores a kill AND player is in enemy team AND it is not first kill in a round AND killer's weapon is grenade
                            --
                            client.log("eventPlayerDeath.hasKilled.enemy.grenade")
                            func_quakeSounds_streakData_update("grenade", i_quakeSounds_current_tickStamp)
                            func_quakeSounds_streakSound_play("grenade")
                        elseif string.find(event.weapon, "knife") ~= nil then
                            --
                            --
                            --  eventPlayerDeath.hasKilled.enemy.knife
                            --  Subblock for playerDeath events AND localplayer scores a kill AND player is in enemy team AND it is not first kill in a round AND killer's weapon is knife
                            --
                            client.log("eventPlayerDeath.hasKilled.enemy.knife")
                            func_quakeSounds_streakData_update("knife", i_quakeSounds_current_tickStamp)
                            func_quakeSounds_streakSound_play("knife")
                        else
                            --
                            --
                            --  eventPlayerDeath.hasKilled.enemy.normal
                            --  Subblock for playerDeath events AND localplayer scores a kill AND player is in enemy team AND it is not first kill in a round
                            --
                            client.log("eventPlayerDeath.hasKilled.enemy.normal")
                            func_quakeSounds_streakData_update("kill", i_quakeSounds_current_tickStamp)
                            func_quakeSounds_streakSound_play("kill")
                        end
                    end

                else
                    --
                    --
                    --  eventPlayerDeath.hasKilled.ally
                    --  Subblock for playerDeath events AND localplayer scores a kill AND player is in ally team
                    --
                    client.log("eventPlayerDeath.hasKilled.ally")
                    if table_contains_element(t_quakeSounds_streakDataSet["snd_teamKill"], "sound") then
                        if b_quakeSounds_stopSound then cvar.stopsound:invoke_callback() end
                        cvar.playvol:invoke_callback(t_quakeSounds_streakDataSet["snd_teamKill"].sound, f_quakeSounds_masterVolume);
                        b_quakeSounds_playerDeath_count = b_quakeSounds_playerDeath_count - 1
                    end
                end
            end
        end
    end

    local function func_quakeSounds_event_playerConnectFull(event)
        entIndex_localEntCCSPlayer = entity.get_local_player();
        g_tickRate = 1 / globals.tickinterval()
        func_quakeSounds_streakData_reset()
    end

    function func_quakeSounds_event_roundStart(event)
        if b_quakeSounds_resetStreakData_OnRoundStart then
            func_quakeSounds_streakData_reset()
        end
        b_quakeSounds_playerDeath_count = 0
    end

    if b_quakeSounds_enable then
        client.set_event_callback("player_death", func_quakeSounds_event_playerDeath)
        client.set_event_callback("player_connect_full", func_quakeSounds_event_playerConnectFull)
        client.set_event_callback("round_start", func_quakeSounds_event_roundStart)
        func_quakeSounds_streakData_reset()
    end

-- [End of file] -------------------------------------------------------------------------------------------------------------------------------------------------