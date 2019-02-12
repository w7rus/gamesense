require("lib_gamesense")
local maf = require("lib_maf")
-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by: w7rus (Astolfo)
-- Credits: Aviarita [lib_gamesense]
--          bjornbytes [lib_maf]

-- [Configuration] --------------------------------------------------------------- [Description] ---------------------------------------------------------------

    b_esp_enable                                           = true               -- <true/false> Master Switch

    b_esp_filter_player                                    = true               -- <true/false> Draw players ESP
    i_esp_filter_playerMode                                = 0                  -- <0/1> Seperate player colors by (relationship/team)
    b_esp_filter_playerEnemy                               = true               -- <true/false> Draw enemy players ESP
    b_esp_filter_playerAlly                                = false              -- <true/false> Draw ally players ESP
    b_esp_filter_playerT                                   = true               -- <true/false> Draw Terrorist Team players ESP
    b_esp_filter_playerCT                                  = true               -- <true/false> Draw Counter-Terrorist Team players ESP

    b_esp_filter_weapon                                    = true               -- <true/false> Draw weapon Entities ESP
    b_esp_filter_mapObjective                              = true               -- <true/false> Draw map objective Entities ESP (Defuse/Rescue Kit and C4)
    b_esp_filter_other                                     = false              -- <true/false> Draw all other Entities

    f_esp_anchorScreenX                                    = 0.5                -- <0.0 ... 1.0> Snaplines Anchor X screen offset (in %) //TODO: Add limitations
    f_esp_anchorScreenY                                    = 0.5                -- <0.0 ... 1.0> Snaplines Anchor Y screen offset (in %) //TODO: Add limitations
    i_esp_paddingScreenXY                                  = 128                -- <0 ... min(client.screen_size())> ESP Screen padding (in px) //TODO: Add limitations

    i_esp_draw_box                                         = 1                  -- <0/1> Draws 3D (Pitch & Yaw & Roll Rotated) box //TODO: Fix Gimbal Lock issue
    b_esp_draw_snapline                                    = true               -- <true/false> Draw Snapline
    b_esp_draw_snaplineEndPoint                            = true               -- <true/false> Draw Snapline Endpoint
    b_esp_draw_name                                        = true               -- <true/false> Draw Entity <classname/name>
    b_esp_draw_health                                      = true               -- <true/false> Draw Entity health (if present)
    b_esp_draw_armor                                       = true               -- <true/false> Draw Entity armor (if present)
    b_esp_draw_weapons                                     = true               -- <true/false> Draw Entity weapons (if present)
    b_esp_draw_ammo                                        = true               -- <true/false> Draw Entity ammo (if present)
    b_esp_draw_distance                                    = true               -- <true/false> Draw distance to Entity
    b_esp_draw_state                                       = true               -- <true/false> Draw Entity state (if present)
    b_esp_draw_navlocation                                 = true               -- <true/false> Draw Entity NAV location (if present)

    b_esp_filter_playerEnemy_accentColor01                 = {255, 0, 170, 255} -- <array typeof char> Invisible enemy players color
    b_esp_filter_playerEnemy_accentColor02                 = {170, 255, 0, 255} -- <array typeof char> Visible enemy players color
    b_esp_filter_playerAlly_accentColor01                  = {0, 170, 255, 255} -- <array typeof char> Invisible ally players color
    b_esp_filter_playerAlly_accentColor02                  = {0, 255, 170, 255} -- <array typeof char> Visible ally players color
    b_esp_filter_playerT_accentColor01                     = {255, 0, 170, 255} -- <array typeof char> Invisible Terrorist Team players color
    b_esp_filter_playerT_accentColor02                     = {170, 255, 0, 255} -- <array typeof char> Visible Terrorist Team players color
    b_esp_filter_playerCT_accentColor01                    = {0, 170, 255, 255} -- <array typeof char> Invisible Counter-Terrorist Team players color
    b_esp_filter_playerCT_accentColor02                    = {0, 255, 170, 255} -- <array typeof char> Visible Counter-Terrorist Team players color
    b_esp_filter_weapons_accentColor01                     = {127, 127, 127, 63}-- <array typeof char> Invisible weapon Entities color
    b_esp_filter_weapons_accentColor02                     = {255, 255, 255, 63}-- <array typeof char> Visible weapon Entities color
    b_esp_filter_mapObjective_accentColor01                = {}                 -- <array typeof char> Invisible map objective Entities color
    b_esp_filter_mapObjective_accentColor02                = {}                 -- <array typeof char> Visible map objective Entities color
    b_esp_filter_other_accentColor01                       = {127, 127, 127, 63}-- <array typeof char> Invisible all other Entities color
    b_esp_filter_other_accentColor02                       = {255, 255, 255, 63}-- <array typeof char> Visible all other Entities color

-- ["Do not edit below this line"] -----------------------------------------------------------------------------------------------------------------------------
-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    entIndex_localEntCCSPlayer                             = entity.get_local_player()
    entIndex_localEntCCSPlayer_kTeamid                     = entity.get_prop(entIndex_localEntCCSPlayer, "m_iTeamNum", array_index)
    i_esp_drawScreenWidth,
    i_esp_drawScreenHeight                                 = client.screen_size()

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

function func_esp_clamptoscreen(mediaScreenWidth, mediaScreenHeight, mediaScreenAnchorX, mediaScreenAnchorY, entityScreenPosX, entityScreenPosY, entityScreenPosPadding)
    if entityScreenPosX <= 0 + entityScreenPosPadding then
        local X_XC_DELTA = math.abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math.abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_YX_RATIO = Y_YC_DELTA / X_XC_DELTA;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math.floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math.floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        entityScreenPosX = 0 + entityScreenPosPadding;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math.floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math.floor(entityScreenPosX * DELTA_YX_RATIO);
        end
    end

    if entityScreenPosX >= mediaScreenWidth - entityScreenPosPadding then
        local X_XC_DELTA = math.abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math.abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_YX_RATIO = -(Y_YC_DELTA / X_XC_DELTA);
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math.floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math.floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        entityScreenPosX = mediaScreenWidth - entityScreenPosPadding;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math.floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math.floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
    end

    if entityScreenPosY <= 0 + entityScreenPosPadding then
        local X_XC_DELTA = math.abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math.abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_XY_RATIO = X_XC_DELTA / Y_YC_DELTA;
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math.floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math.floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        entityScreenPosY = (0 + entityScreenPosPadding);
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math.floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math.floor(entityScreenPosY * DELTA_XY_RATIO);
        end
    end

    if entityScreenPosY >= mediaScreenHeight - entityScreenPosPadding then
        local X_XC_DELTA = math.abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math.abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_XY_RATIO = -(X_XC_DELTA / Y_YC_DELTA);
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math.floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math.floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        entityScreenPosY = mediaScreenHeight - entityScreenPosPadding;
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math.floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math.floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
    end

    return entityScreenPosX, entityScreenPosY;
end
function func_esp_rainbowize(a,b,c,d,e,f,g)local h,i,j=math.cos(a*(f+g))*b+math.floor(b/2),math.cos(a*(f+g)+2*math.pi/3*c)*b+math.floor(b/2),math.cos(a*(f+g)-2*math.pi/3*c)*b+math.floor(b/2)if h<d then h=d end;if j<d then j=d end;if i<d then i=d end;if h>e then h=e end;if j>e then j=e end;if i>e then i=e end;return {h,i,j} end

local rotate = function(pitch, yaw, roll, nodes)
    for i = 1, #nodes do
        local vec = maf.vec3(nodes[i].x, nodes[i].y, nodes[i].z)

        local p, y, r = .5 * math.rad(pitch), .5 * math.rad(yaw), .5 * math.rad(roll)
        local cx = math.cos(p)
        local sx = math.sin(p)
        local cy = math.cos(y)
        local sy = math.sin(y)
        local cz = math.cos(r)
        local sz = math.sin(r)

        local x = sx * cy * cz - cx * sy * sz
        local y = cx * sy * cz + sx * cy * sz
        local z = cx * cy * sz - sx * sy * cz
        local w = cx * cy * cz + sx * sy * sz

        local rot = maf.quat(x, z, y, w)
        vec:rotate(rot)
        nodes[i] = vec
    end
end

function func_esp_drawSnapLine(entIndex_serverEntCAny, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()

    local i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPos.x, vec_serverEntCAny_WorldPos.y, vec_serverEntCAny_WorldPos.z)

    if i_serverEntCAny_ScreenPosX ~= nil and i_serverEntCAny_ScreenPosY ~= nil then
        i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = func_esp_clamptoscreen(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_paddingScreenXY)

        if obj_serverEntCAny:is_player() == true then
            obj_serverEntCAny = Player(entIndex_serverEntCAny)
            vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_hitbox_pos("head_0")
        end

        b_serverEntCAny_IsVisible = obj_localEntCCSPlayer:can_see_point(vec_serverEntCAny_WorldPos)

        if b_esp_draw_snaplineEndPoint == true then
            renderer.rectangle(i_serverEntCAny_ScreenPosX - 3, i_serverEntCAny_ScreenPosY - 3, 7, 7, 0, 0, 0, 127)

            if b_serverEntCAny_IsVisible == true then
                renderer.rectangle(i_serverEntCAny_ScreenPosX - 2, i_serverEntCAny_ScreenPosY - 2, 5, 5, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
            else
                renderer.rectangle(i_serverEntCAny_ScreenPosX - 2, i_serverEntCAny_ScreenPosY - 2, 5, 5, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
            end
        end

        if b_esp_draw_snapline == true then
            if b_serverEntCAny_IsVisible == true then
                renderer.line(i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_anchorPosX, i_esp_anchorPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
            else
                renderer.line(i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_anchorPosX, i_esp_anchorPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
            end
        end
    end
end

function func_esp_drawBoxStatic(entIndex_serverEntCAny, accentColor01, accentColor02)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local vec_serverEntCAny_WorldPos = {x, y, z}
    vec_serverEntCAny_WorldPos.x = 0
    vec_serverEntCAny_WorldPos.y = 0
    vec_serverEntCAny_WorldPos.z = 0

    local vec_serverEntCAny_WorldAng = {pitch, yaw, roll}
    vec_serverEntCAny_WorldAng.pitch = 0
    vec_serverEntCAny_WorldAng.yaw = 0
    vec_serverEntCAny_WorldAng.roll = 0

    vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()
    vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldAng.roll = entity.get_prop(entIndex_serverEntCAny, "m_angRotation", array_index)
    local vec_serverEntCAny_WorldPosVecMins = obj_serverEntCAny:get_vec_mins()
    local vec_serverEntCAny_WorldPosVecMaxs = obj_serverEntCAny:get_vec_maxs()

    local vec_serverEntCAny_WorldPosP1 = {x, y, z}
    vec_serverEntCAny_WorldPosP1.x = vec_serverEntCAny_WorldPosVecMins.x
    vec_serverEntCAny_WorldPosP1.y = vec_serverEntCAny_WorldPosVecMins.y
    vec_serverEntCAny_WorldPosP1.z = vec_serverEntCAny_WorldPosVecMins.z

    local vec_serverEntCAny_WorldPosP2 = {x, y, z}
    vec_serverEntCAny_WorldPosP2.x = vec_serverEntCAny_WorldPosVecMaxs.x
    vec_serverEntCAny_WorldPosP2.y = vec_serverEntCAny_WorldPosVecMins.y
    vec_serverEntCAny_WorldPosP2.z = vec_serverEntCAny_WorldPosVecMins.z

    local vec_serverEntCAny_WorldPosP3 = {x, y, z}
    vec_serverEntCAny_WorldPosP3.x = vec_serverEntCAny_WorldPosVecMaxs.x
    vec_serverEntCAny_WorldPosP3.y = vec_serverEntCAny_WorldPosVecMaxs.y
    vec_serverEntCAny_WorldPosP3.z = vec_serverEntCAny_WorldPosVecMins.z

    local vec_serverEntCAny_WorldPosP4 = {x, y, z}
    vec_serverEntCAny_WorldPosP4.x = vec_serverEntCAny_WorldPosVecMins.x
    vec_serverEntCAny_WorldPosP4.y = vec_serverEntCAny_WorldPosVecMaxs.y
    vec_serverEntCAny_WorldPosP4.z = vec_serverEntCAny_WorldPosVecMins.z

    local vec_serverEntCAny_WorldPosP5 = {x, y, z}
    vec_serverEntCAny_WorldPosP5.x = vec_serverEntCAny_WorldPosVecMins.x
    vec_serverEntCAny_WorldPosP5.y = vec_serverEntCAny_WorldPosVecMins.y
    vec_serverEntCAny_WorldPosP5.z = vec_serverEntCAny_WorldPosVecMaxs.z

    local vec_serverEntCAny_WorldPosP6 = {x, y, z}
    vec_serverEntCAny_WorldPosP6.x = vec_serverEntCAny_WorldPosVecMaxs.x
    vec_serverEntCAny_WorldPosP6.y = vec_serverEntCAny_WorldPosVecMins.y
    vec_serverEntCAny_WorldPosP6.z = vec_serverEntCAny_WorldPosVecMaxs.z

    local vec_serverEntCAny_WorldPosP7 = {x, y, z}
    vec_serverEntCAny_WorldPosP7.x = vec_serverEntCAny_WorldPosVecMaxs.x
    vec_serverEntCAny_WorldPosP7.y = vec_serverEntCAny_WorldPosVecMaxs.y
    vec_serverEntCAny_WorldPosP7.z = vec_serverEntCAny_WorldPosVecMaxs.z

    local vec_serverEntCAny_WorldPosP8 = {x, y, z}
    vec_serverEntCAny_WorldPosP8.x = vec_serverEntCAny_WorldPosVecMins.x
    vec_serverEntCAny_WorldPosP8.y = vec_serverEntCAny_WorldPosVecMaxs.y
    vec_serverEntCAny_WorldPosP8.z = vec_serverEntCAny_WorldPosVecMaxs.z

    local vec_serverEntCAny_WorldPosP1P8 = {vec_serverEntCAny_WorldPosP1, vec_serverEntCAny_WorldPosP2, vec_serverEntCAny_WorldPosP3, vec_serverEntCAny_WorldPosP4, vec_serverEntCAny_WorldPosP5, vec_serverEntCAny_WorldPosP6, vec_serverEntCAny_WorldPosP7, vec_serverEntCAny_WorldPosP8}

    rotate(vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldAng.roll, vec_serverEntCAny_WorldPosP1P8)

    -- rotateY3D(vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldPosP1P8)
    -- rotateZ3D(vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldPosP1P8)
    -- rotateX3D(vec_serverEntCAny_WorldAng.roll, vec_serverEntCAny_WorldPosP1P8)

    vec_serverEntCAny_WorldPosP1.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[1].x
    vec_serverEntCAny_WorldPosP1.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[1].y
    vec_serverEntCAny_WorldPosP1.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[1].z

    vec_serverEntCAny_WorldPosP2.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[2].x
    vec_serverEntCAny_WorldPosP2.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[2].y
    vec_serverEntCAny_WorldPosP2.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[2].z

    vec_serverEntCAny_WorldPosP3.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[3].x
    vec_serverEntCAny_WorldPosP3.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[3].y
    vec_serverEntCAny_WorldPosP3.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[3].z

    vec_serverEntCAny_WorldPosP4.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[4].x
    vec_serverEntCAny_WorldPosP4.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[4].y
    vec_serverEntCAny_WorldPosP4.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[4].z

    vec_serverEntCAny_WorldPosP5.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[5].x
    vec_serverEntCAny_WorldPosP5.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[5].y
    vec_serverEntCAny_WorldPosP5.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[5].z

    vec_serverEntCAny_WorldPosP6.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[6].x
    vec_serverEntCAny_WorldPosP6.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[6].y
    vec_serverEntCAny_WorldPosP6.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[6].z

    vec_serverEntCAny_WorldPosP7.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[7].x
    vec_serverEntCAny_WorldPosP7.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[7].y
    vec_serverEntCAny_WorldPosP7.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[7].z

    vec_serverEntCAny_WorldPosP8.x = vec_serverEntCAny_WorldPos.x + vec_serverEntCAny_WorldPosP1P8[8].x
    vec_serverEntCAny_WorldPosP8.y = vec_serverEntCAny_WorldPos.y + vec_serverEntCAny_WorldPosP1P8[8].y
    vec_serverEntCAny_WorldPosP8.z = vec_serverEntCAny_WorldPos.z + vec_serverEntCAny_WorldPosP1P8[8].z

    local i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP1.x, vec_serverEntCAny_WorldPosP1.y, vec_serverEntCAny_WorldPosP1.z)
    local i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP2.x, vec_serverEntCAny_WorldPosP2.y, vec_serverEntCAny_WorldPosP2.z)
    local i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP3.x, vec_serverEntCAny_WorldPosP3.y, vec_serverEntCAny_WorldPosP3.z)
    local i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP4.x, vec_serverEntCAny_WorldPosP4.y, vec_serverEntCAny_WorldPosP4.z)
    local i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP5.x, vec_serverEntCAny_WorldPosP5.y, vec_serverEntCAny_WorldPosP5.z)
    local i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP6.x, vec_serverEntCAny_WorldPosP6.y, vec_serverEntCAny_WorldPosP6.z)
    local i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP7.x, vec_serverEntCAny_WorldPosP7.y, vec_serverEntCAny_WorldPosP7.z)
    local i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY = renderer.world_to_screen(vec_serverEntCAny_WorldPosP8.x, vec_serverEntCAny_WorldPosP8.y, vec_serverEntCAny_WorldPosP8.z)

    if  i_serverEntCAny_P1ScreenPosX ~= nil and i_serverEntCAny_P1ScreenPosY ~= nil and
        i_serverEntCAny_P2ScreenPosX ~= nil and i_serverEntCAny_P2ScreenPosY ~= nil and
        i_serverEntCAny_P3ScreenPosX ~= nil and i_serverEntCAny_P3ScreenPosY ~= nil and
        i_serverEntCAny_P4ScreenPosX ~= nil and i_serverEntCAny_P4ScreenPosY ~= nil and
        i_serverEntCAny_P5ScreenPosX ~= nil and i_serverEntCAny_P5ScreenPosY ~= nil and
        i_serverEntCAny_P6ScreenPosX ~= nil and i_serverEntCAny_P6ScreenPosY ~= nil and
        i_serverEntCAny_P7ScreenPosX ~= nil and i_serverEntCAny_P7ScreenPosY ~= nil and
        i_serverEntCAny_P8ScreenPosX ~= nil and i_serverEntCAny_P8ScreenPosY ~= nil then

        if obj_serverEntCAny:is_player() == true then
            obj_serverEntCAny = Player(entIndex_serverEntCAny)
            vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_hitbox_pos("head_0")
        end

        b_serverEntCAny_IsVisible = obj_localEntCCSPlayer:can_see_point(vec_serverEntCAny_WorldPos)

        if i_esp_draw_box > 0 then
            if b_serverEntCAny_IsVisible == true then
                -- Bottom
                renderer.line(i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                -- Top
                renderer.line(i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                -- Sides
                renderer.line(i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
                renderer.line(i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
            else
                -- Bottom
                renderer.line(i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                -- Top
                renderer.line(i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                -- Sides
                renderer.line(i_serverEntCAny_P1ScreenPosX, i_serverEntCAny_P1ScreenPosY, i_serverEntCAny_P5ScreenPosX, i_serverEntCAny_P5ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P2ScreenPosX, i_serverEntCAny_P2ScreenPosY, i_serverEntCAny_P6ScreenPosX, i_serverEntCAny_P6ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P3ScreenPosX, i_serverEntCAny_P3ScreenPosY, i_serverEntCAny_P7ScreenPosX, i_serverEntCAny_P7ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
                renderer.line(i_serverEntCAny_P4ScreenPosX, i_serverEntCAny_P4ScreenPosY, i_serverEntCAny_P8ScreenPosX, i_serverEntCAny_P8ScreenPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
            end
        end
    end
end

function func_esp_drawPlayerInfo(entIndex_serverEntCCSPlayer, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCCSPlayer_WorldPos = obj_serverEntCCSPlayer:get_vec_origin()

    local i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY = renderer.world_to_screen(i_serverEntCCSPlayer_WorldPos.x, i_serverEntCCSPlayer_WorldPos.y, i_serverEntCCSPlayer_WorldPos.z)

    if i_serverEntCCSPlayer_ScreenPosX ~= nil and i_serverEntCCSPlayer_ScreenPosY ~= nil then
        i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY = func_esp_clamptoscreen(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY, i_esp_paddingScreenXY)

        local i_esp_draw_strOffset = 1
        --
        --
        --  Name
        --
        --
        if b_esp_draw_name == true then
            local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer.measure_text("b", "Name: " .. obj_serverEntCCSPlayer:get_name())

            renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Name: " .. obj_serverEntCCSPlayer:get_name())

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Health
        --
        --
        if b_esp_draw_health == true then
            local i_esp_draw_health_strSizeX, i_esp_draw_health_strSizeY = renderer.measure_text("b", "Health: " .. obj_serverEntCCSPlayer:get_health() .. "%")

            renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_health_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_health_strSizeY * i_esp_draw_strOffset, i_esp_draw_health_strSizeX + 8, i_esp_draw_health_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_health_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_health_strSizeY * i_esp_draw_strOffset, 255 - 255 * obj_serverEntCCSPlayer:get_health() / 100, 255 * obj_serverEntCCSPlayer:get_health() / 100, 0, 255, "b", 0, "Health: " .. obj_serverEntCCSPlayer:get_health() .. "%")

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Armor
        --
        --
        if b_esp_draw_armor == true then
            if obj_serverEntCCSPlayer:playerresource():get_armor() > 0 then
                local i_esp_draw_armor_strSizeX, i_esp_draw_armor_strSizeY = renderer.measure_text("b", "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_armor_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset, i_esp_draw_armor_strSizeX + 8, i_esp_draw_armor_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_armor_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 255, "b", 0, "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
        end
        --
        --
        --  Distance
        --
        --
        if b_esp_draw_distance == true then
            local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

            local value = math.sqrt((i_serverEntCCSPlayer_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCCSPlayer_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCCSPlayer_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
            local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer.measure_text("b", "Distance: " .. string.format("%d", value) .. " u.")

            renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. " u.")

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  NAV Location
        --
        --
        if b_esp_draw_navlocation == true then
            local str_esp_draw_navlocation = entity.get_prop(entIndex_serverEntCCSPlayer, "m_szLastPlaceName", array_index)

            local i_esp_draw_navlocation_strSizeX, i_esp_draw_navlocation_strSizeY = renderer.measure_text("b", "Location: " .. str_esp_draw_navlocation)

            renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_navlocation_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, i_esp_draw_navlocation_strSizeX + 8, i_esp_draw_navlocation_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_navlocation_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Location: " .. str_esp_draw_navlocation)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end

        --
        --
        --  Weapons
        --
        --
        i_esp_draw_strOffset = i_esp_draw_strOffset + 1

        if b_esp_draw_weapons == true then
            local arr_esp_draw_weapons = obj_serverEntCCSPlayer:get_all_weapons()
            for i = 1, #arr_esp_draw_weapons do
                local ent_esp_draw_weapon = arr_esp_draw_weapons[i]

                local str_esp_draw_weapon = ""

                if b_esp_draw_ammo == true and not(ent_esp_draw_weapon:is_knife()) and ent_esp_draw_weapon:get_current_ammo() ~= nil and ent_esp_draw_weapon:get_max_ammo() ~= nil then
                    str_esp_draw_weapon = ent_esp_draw_weapon:get_name() .. " (" .. ent_esp_draw_weapon:get_current_ammo() .. "/" .. ent_esp_draw_weapon:get_max_ammo() .. ")"
                else
                    str_esp_draw_weapon = ent_esp_draw_weapon:get_name()
                end

                local i_esp_draw_weapon_strSizeX, i_esp_draw_weapon_strSizeY = renderer.measure_text("b", str_esp_draw_weapon)

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, i_esp_draw_weapon_strSizeX + 8, i_esp_draw_weapon_strSizeY, 0, 0, 0, 127)

                if ent_esp_draw_weapon:get_index() == obj_serverEntCCSPlayer:get_active_weapon():get_index() then
                    renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, str_esp_draw_weapon)
                else
                    renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_weapon)
                end

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
        end

        i_esp_draw_strOffset = i_esp_draw_strOffset + 1

        --
        --
        --  Player State
        --
        --
        if b_esp_draw_state == true then
            --
            --
            --  Is Scoped
            --
            --
            if obj_serverEntCCSPlayer:is_scoped() then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "Scoped")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, "Scoped")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Is Flashed
            --
            --
            if obj_serverEntCCSPlayer:is_flashed() then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "Flashed")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 193, 240, 255, 255, "b", 0, "Flashed")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Has Bomb
            --
            --
            if obj_serverEntCCSPlayer:has_bomb() then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "Bombcarrier")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 127, 0, 255, "b", 0, "Bombcarrier")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Has Defuser
            --
            --
            if obj_serverEntCCSPlayer:has_defuser() then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "Has Kit")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 0, 127, 255, 255, "b", 0, "Has Kit")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Is In Air
            --
            --
            if bit.band(obj_serverEntCCSPlayer:get_flags(), 1) ~= 1 then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "In Air")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Air")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Is Ducking
            --
            --
            if bit.band(obj_serverEntCCSPlayer:get_flags(), 2) == 2 and bit.band(obj_serverEntCCSPlayer:get_flags(), 3) == 3 and bit.band(obj_serverEntCCSPlayer:get_flags(), 4) == 4 then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "Ducking")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Ducking")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Is In Water
            --
            --
            if bit.band(obj_serverEntCCSPlayer:get_flags(), 10) == 10 then
                local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer.measure_text("b", "In Water")

                renderer.rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                renderer.text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Water")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
        end
    end
end

function func_esp_drawWeaponInfo(entIndex_serverEntCWeaponCSBase, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCWeaponCSBase = Entity(entIndex_serverEntCWeaponCSBase)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCWeaponCSBase_WorldPos = obj_serverEntCWeaponCSBase:get_vec_origin()

    local i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY = renderer.world_to_screen(i_serverEntCWeaponCSBase_WorldPos.x, i_serverEntCWeaponCSBase_WorldPos.y, i_serverEntCWeaponCSBase_WorldPos.z)

    obj_serverEntCWeaponCSBase = Weapon(entIndex_serverEntCWeaponCSBase)

    if i_serverEntCWeaponCSBase_ScreenPosX ~= nil and i_serverEntCWeaponCSBase_ScreenPosY ~= nil then
        i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY = func_esp_clamptoscreen(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY, i_esp_paddingScreenXY)

        local i_esp_draw_strOffset = 1
        --
        --
        --  Name
        --
        --
        if b_esp_draw_name == true then
            local str_esp_draw_weapon = ""

            if b_esp_draw_ammo == true then
                if entity.get_classname(entIndex_serverEntCWeaponCSBase) ~= "CWeaponTaser" then
                    str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. obj_serverEntCWeaponCSBase:get_current_ammo() .. "/" .. obj_serverEntCWeaponCSBase:get_max_ammo() .. ")"
                else
                    if entity.get_prop(entIndex_serverEntCWeaponCSBase, "m_iClip1", array_index) > 0 then
                        str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. "Charged" .. ")"
                    else
                        str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. "Empty" .. ")"
                    end
                end
            else
                str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name()
            end
            local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer.measure_text("b", str_esp_draw_weapon)

            renderer.rectangle(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_weapon)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Distance
        --
        --
        if b_esp_draw_distance == true then
            local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

            local value = math.sqrt((i_serverEntCWeaponCSBase_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCWeaponCSBase_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCWeaponCSBase_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
            local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer.measure_text("b", "Distance: " .. string.format("%d", value) .. " u.")

            renderer.rectangle(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. " u.")

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
    end
end

function func_esp_drawEntityInfo(entIndex_serverEntCAny, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()

    local i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = renderer.world_to_screen(i_serverEntCAny_WorldPos.x, i_serverEntCAny_WorldPos.y, i_serverEntCAny_WorldPos.z)

    if i_serverEntCAny_ScreenPosX ~= nil and i_serverEntCAny_ScreenPosY ~= nil then
        i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = func_esp_clamptoscreen(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_paddingScreenXY)

        local i_esp_draw_strOffset = 1
        --
        --
        --  Name
        --
        --
        if b_esp_draw_name == true then
            local str_esp_draw_name = ""

            local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY

            if entity.get_classname(entIndex_serverEntCAny) == "CC4" then
                str_esp_draw_name = "C4"
            elseif entity.get_classname(entIndex_serverEntCAny) == "CPlantedC4" then
                -- TODO: Add timer
                str_esp_draw_name = "C4 (Planted)"
            elseif entity.get_classname(entIndex_serverEntCAny) == "CHostage" then
                str_esp_draw_name = "Hostage"
            elseif entity.get_classname(entIndex_serverEntCAny) == "CEconEntity" then
                str_esp_draw_name = "Kit"
            else
                str_esp_draw_name = obj_serverEntCAny:get_classname()
            end

            i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer.measure_text("b", str_esp_draw_name)

            renderer.rectangle(i_serverEntCAny_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCAny_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCAny_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCAny_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_name)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Distance
        --
        --
        if b_esp_draw_distance == true then
            local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

            local value = math.sqrt((i_serverEntCAny_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCAny_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCAny_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
            local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer.measure_text("b", "Distance: " .. string.format("%d", value) .. " u.")

            renderer.rectangle(i_serverEntCAny_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCAny_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

            renderer.text(i_serverEntCAny_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCAny_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. " u.")

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
    end
end

function func_esp_draw(ctx)
    local i_esp_anchorPosX = math.floor(i_esp_drawScreenWidth * f_esp_anchorScreenX)
    local i_esp_anchorPosY = math.floor(i_esp_drawScreenHeight * f_esp_anchorScreenY)

    local f_esp_globalRealtime = globals.realtime()

    entIndex_localEntCCSPlayer = entity.get_local_player();
    entIndex_localEntCCSPlayer_kTeamid = entity.get_prop(entIndex_localEntCCSPlayer, "m_iTeamNum", array_index)

    b_esp_filter_mapObjective_accentColor01 = func_esp_rainbowize(4, 255, 1, 0, 255, f_esp_globalRealtime, 0, 127)
    b_esp_filter_mapObjective_accentColor02 = func_esp_rainbowize(4, 255, 1, 0, 255, f_esp_globalRealtime, 0, 255)

    b_esp_filter_mapObjective_accentColor01[4] = 255
    b_esp_filter_mapObjective_accentColor02[4] = 255

    if b_esp_filter_player == true then
        local arr_entIndex_serverEntCCSPlayer = entity.get_players(false)
        if i_esp_filter_playerMode == 0 then --Differentiate by relationship
            for i = 1, #arr_entIndex_serverEntCCSPlayer do
                local entIndex_serverEntCCSPlayer = arr_entIndex_serverEntCCSPlayer[i]
                local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)

                if obj_serverEntCCSPlayer:is_alive() then
                    local i_serverEntCCSPlayer_kTeamid = obj_serverEntCCSPlayer:get_teamnum()

                    if b_esp_filter_playerEnemy == true then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid ~= entIndex_localEntCCSPlayer_kTeamid then
                            func_esp_drawSnapLine(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02)
                        end
                    end

                    if b_esp_filter_playerAlly == true then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == entIndex_localEntCCSPlayer_kTeamid then
                            func_esp_drawSnapLine(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02)
                        end
                    end
                end
            end
        end
        if i_esp_filter_playerMode == 1 then --Differentiate by team
            for i = 1, #arr_entIndex_serverEntCCSPlayer do
                local entIndex_serverEntCCSPlayer = arr_entIndex_serverEntCCSPlayer[i]
                local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)

                if obj_serverEntCCSPlayer:is_alive() then
                    local i_serverEntCCSPlayer_kTeamid = obj_serverEntCCSPlayer:get_teamnum()

                    if b_esp_filter_playerT == true then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == 2 then
                            func_esp_drawSnapLine(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02)
                        end
                    end

                    if b_esp_filter_playerCT == true then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == 3 then
                            func_esp_drawSnapLine(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_esp_drawBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02)
                        end
                    end
                end
            end
        end
    end

    if b_esp_filter_weapon == true then
        local arr_entIndex_serverEntCWeaponCSBase = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCWeaponCSBase do
            local entIndex_serverEntCWeaponCSBase = arr_entIndex_serverEntCWeaponCSBase[i]

            local obj_serverEntCWeaponCSBase = Entity(entIndex_serverEntCWeaponCSBase)

            if (string.find(entity.get_classname(entIndex_serverEntCWeaponCSBase), "CWeapon") ~= nil or 
                string.find(entity.get_classname(entIndex_serverEntCWeaponCSBase), "CDEagle") ~= nil or 
                string.find(entity.get_classname(entIndex_serverEntCWeaponCSBase), "CAK47") ~= nil) and entity.get_prop(entIndex_serverEntCWeaponCSBase, "m_hOwner", array_index) == nil then
                func_esp_drawSnapLine(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_esp_drawWeaponInfo(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                -- func_esp_drawBoxStatic(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02)
            end
        end
    end

    if b_esp_filter_mapObjective == true then
        local arr_entIndex_serverEntCAny = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCAny do
            local entIndex_serverEntCAny = arr_entIndex_serverEntCAny[i]

            if ((string.find(entity.get_classname(entIndex_serverEntCAny), "CC4") ~= nil and entity.get_prop(entIndex_serverEntCAny, "m_hOwner", array_index) == nil) or 
                string.find(entity.get_classname(entIndex_serverEntCAny), "CHostage") ~= nil or
                string.find(entity.get_classname(entIndex_serverEntCAny), "CEconEntity") ~= nil or
                string.find(entity.get_classname(entIndex_serverEntCAny), "CPlantedC4") ~= nil) then
                func_esp_drawSnapLine(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_esp_drawEntityInfo(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_esp_drawBoxStatic(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02)
            end
        end
    end

    if b_esp_filter_other == true then
        local arr_entIndex_serverEntCAny = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCAny do
            local entIndex_serverEntCAny = arr_entIndex_serverEntCAny[i]

            if (string.find(entity.get_classname(entIndex_serverEntCAny), "CWeapon") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CDEagle") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CAK47") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CCSPlayer") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CCSTeam") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CC4") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CHostage") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CEconEntity") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CPlantedC4") == nil and
                string.find(entity.get_classname(entIndex_serverEntCAny), "CCSGameRulesProxy") == nil) then             -- entity which does not have origin
                    func_esp_drawSnapLine(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                    func_esp_drawEntityInfo(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                    func_esp_drawBoxStatic(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02)
            end
        end
    end
end

if b_esp_enable == true then
    client.set_event_callback("paint", func_esp_draw)
end

-- [End of file] -----------------------------------------------------------------------------------------------------------------------------------------------