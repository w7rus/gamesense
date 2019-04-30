require("lib_gamesense")
local maf = require("lib_maf")

local ui_new_checkbox = ui.new_checkbox
local ui_new_combobox = ui.new_combobox
local ui_new_multiselect = ui.new_multiselect
local ui_new_slider = ui.new_slider
local ui_new_button = ui.new_button
local ui_new_color_picker = ui.new_color_picker
local ui_set_callback = ui.set_callback
local ui_get = ui.get
local ui_set = ui.set
local ui_reference = ui.reference
local ui_set_visible = ui.set_visible

local math_abs = math.abs
local math_floor = math.floor
local math_cos = math.cos
local math_sin = math.sin
local math_max = math.max
local math_min = math.min

local renderer_world_to_screen = renderer.world_to_screen
local renderer_text = renderer.text
local renderer_rectangle = renderer.rectangle
local renderer_line = renderer.line
local renderer_measure_text = renderer.measure_text

local entity_get_local_player = entity.get_local_player
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_get_prop = entity.get_prop

local string_find = string.find
local string_match = string.match

-- [About]------------------------------------------------------------------------------------------------------------------------------------------------------
-- Made by: w7rus (Astolfo)
-- Credits: Aviarita [lib_gamesense]
--          bjornbytes [lib_maf]

-- [Configuration] ["Do not edit below this line"]-------------------------------- [Value/Description] ---------------------------------------------------------

    local ref_extesp_enable                                                     = ui_new_checkbox("VISUALS", "Player ESP", "Ext-ESP")

    local ref_extesp_filter_players                                             = ui_new_combobox("VISUALS", "Player ESP", "Players", {"Off", "On (Ally/Enemy)", "On (CT/T)"})
    local ref_extesp_filter_playersSubtype                                      = ui_new_multiselect("VISUALS", "Player ESP", "Player Subtype", {"Ally", "Enemy", "CT", "T"})

    local ref_extesp_filter_weapons                                             = ui_new_checkbox("VISUALS", "Player ESP", "Weapons")
    local ref_extesp_filter_mapObjective                                        = ui_new_checkbox("VISUALS", "Player ESP", "Objectives")
    local ref_extesp_filter_projectiles                                         = ui_new_combobox("VISUALS", "Player ESP", "Projectiles", {"Off", "On (Owner)", "On (Subtype)"})
    local ref_extesp_filter_other                                               = ui_new_checkbox("VISUALS", "Player ESP", "Other")

    local ref_extesp_boundingBox                                                = ui_new_combobox("VISUALS", "Player ESP", "Any > Bounding Box", {"Off", "On (Static 3D)", "On (Static 2D)"})
    local ref_extesp_snapline                                                   = ui_new_checkbox("VISUALS", "Player ESP", "Any > Snapline")
    local ref_extesp_snaplineStartX                                             = ui_new_slider("VISUALS", "Player ESP", "Any > Snapline (Start X)", 0, 100, 50, true, "%", 1)
    local ref_extesp_snaplineStartY                                             = ui_new_slider("VISUALS", "Player ESP", "Any > Snapline (Start Y)", 0, 100, 50, true, "%", 1)
    local ref_extesp_originPoint                                                = ui_new_checkbox("VISUALS", "Player ESP", "Any > Origin Point")
    local ref_extesp_skeleton                                                   = ui_new_checkbox("VISUALS", "Player ESP", "Any > Skeleton")
    local ref_extesp_name                                                       = ui_new_checkbox("VISUALS", "Player ESP", "Any > Name/Classname")
    local ref_extesp_health                                                     = ui_new_checkbox("VISUALS", "Player ESP", "Any > Health")
    local ref_extesp_armor                                                      = ui_new_checkbox("VISUALS", "Player ESP", "Any > Armor")
    local ref_extesp_distance                                                   = ui_new_combobox("VISUALS", "Player ESP", "Any > Distance", {"Off", "Units", "Metric", "Imperial"})
    local ref_extesp_navlocation                                                = ui_new_checkbox("VISUALS", "Player ESP", "Any > NAV Location")
    local ref_extesp_equipment                                                  = ui_new_checkbox("VISUALS", "Player ESP", "Any > Equipment")
    local ref_extesp_ammo                                                       = ui_new_checkbox("VISUALS", "Player ESP", "Any > Equipment > Ammo")
    local ref_extesp_flags                                                      = ui_new_checkbox("VISUALS", "Player ESP", "Any > Flags")

    local ref_extesp_padding                                                    = ui_new_slider("VISUALS", "Player ESP", "Any > Screen Padding", 0, math_floor(math_min(client.screen_size()) / 2), 128, true, "px", 1)

    local b_esp_filter_playerEnemy_accentColor01                                = {255, 0, 170, 255}
    local b_esp_filter_playerEnemy_accentColor02                                = {170, 255, 0, 255}
    local b_esp_filter_playerAlly_accentColor01                                 = {0, 170, 255, 255}
    local b_esp_filter_playerAlly_accentColor02                                 = {0, 255, 170, 255}
    local b_esp_filter_playerEnemy_accentColor01_label                          = ui_new_checkbox("VISUALS", "Player ESP", "Players > Enemy (Color Invis.)")
    local b_esp_filter_playerEnemy_accentColor01_colorPicker                    = ui_new_color_picker("VISUALS", "Player ESP", "Players > Enemy (Color Invis.)", 255, 0, 170, 255)
    ui.set_callback(b_esp_filter_playerEnemy_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerEnemy_accentColor01_colorPicker);
        b_esp_filter_playerEnemy_accentColor01 = {r, g, b , a}
    end)
    local b_esp_filter_playerEnemy_accentColor02_label                          = ui_new_checkbox("VISUALS", "Player ESP", "Players > Enemy (Color Vis.)")
    local b_esp_filter_playerEnemy_accentColor02_colorPicker                    = ui_new_color_picker("VISUALS", "Player ESP", "Players > Enemy (Color Vis.)", 170, 255, 0, 255)
    ui.set_callback(b_esp_filter_playerEnemy_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerEnemy_accentColor02_colorPicker);
        b_esp_filter_playerEnemy_accentColor02 = {r, g, b , a}
    end)
    local b_esp_filter_playerAlly_accentColor01_label                           = ui_new_checkbox("VISUALS", "Player ESP", "Players > Ally (Color Invis.)")
    local b_esp_filter_playerAlly_accentColor01_colorPicker                     = ui_new_color_picker("VISUALS", "Player ESP", "Players > Ally (Color Invis.)", 0, 170, 255, 255)
    ui.set_callback(b_esp_filter_playerAlly_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerAlly_accentColor01_colorPicker);
        b_esp_filter_playerAlly_accentColor01 = {r, g, b , a}
    end)
    local b_esp_filter_playerAlly_accentColor02_label                           = ui_new_checkbox("VISUALS", "Player ESP", "Players > Ally (Color Vis.)")
    local b_esp_filter_playerAlly_accentColor02_colorPicker                     = ui_new_color_picker("VISUALS", "Player ESP", "Players > Ally (Color Vis.)", 0, 255, 170, 255)
    ui.set_callback(b_esp_filter_playerAlly_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerAlly_accentColor02_colorPicker);
        b_esp_filter_playerAlly_accentColor02 = {r, g, b , a}
    end)

    local b_esp_filter_playerT_accentColor01                                    = {255, 0, 170, 255}
    local b_esp_filter_playerT_accentColor02                                    = {170, 255, 0, 255}
    local b_esp_filter_playerCT_accentColor01                                   = {0, 170, 255, 255}
    local b_esp_filter_playerCT_accentColor02                                   = {0, 255, 170, 255}
    local b_esp_filter_playerT_accentColor01_label                              = ui_new_checkbox("VISUALS", "Player ESP", "Players > T (Color Invis.)")
    local b_esp_filter_playerT_accentColor01_colorPicker                        = ui_new_color_picker("VISUALS", "Player ESP", "Players > T (Color Invis.)", 255, 0, 170, 255)
    ui.set_callback(b_esp_filter_playerT_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerT_accentColor01_colorPicker);
        b_esp_filter_playerT_accentColor01 = {r, g, b , a}
    end)
    local b_esp_filter_playerT_accentColor02_label                              = ui_new_checkbox("VISUALS", "Player ESP", "Players > T (Color Vis.)")
    local b_esp_filter_playerT_accentColor02_colorPicker                        = ui_new_color_picker("VISUALS", "Player ESP", "Players > T (Color Vis.)", 170, 255, 0, 255)
    ui.set_callback(b_esp_filter_playerT_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerT_accentColor02_colorPicker);
        b_esp_filter_playerT_accentColor02 = {r, g, b , a}
    end)
    local b_esp_filter_playerCT_accentColor01_label                             = ui_new_checkbox("VISUALS", "Player ESP", "Players > CT (Color Invis.)")
    local b_esp_filter_playerCT_accentColor01_colorPicker                       = ui_new_color_picker("VISUALS", "Player ESP", "Players > CT (Color Invis.)", 0, 170, 255, 255)
    ui.set_callback(b_esp_filter_playerCT_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerCT_accentColor01_colorPicker);
        b_esp_filter_playerCT_accentColor01 = {r, g, b , a}
    end)
    local b_esp_filter_playerCT_accentColor02_label                             = ui_new_checkbox("VISUALS", "Player ESP", "Players > CT (Color Vis.)")
    local b_esp_filter_playerCT_accentColor02_colorPicker                       = ui_new_color_picker("VISUALS", "Player ESP", "Players > CT (Color Vis.)", 0, 255, 170, 255)
    ui.set_callback(b_esp_filter_playerCT_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_playerCT_accentColor02_colorPicker);
        b_esp_filter_playerCT_accentColor02 = {r, g, b , a}
    end)

    local b_esp_filter_weapons_accentColor01                                    = {127, 127, 127, 63}
    local b_esp_filter_weapons_accentColor02                                    = {255, 255, 255, 63}
    local b_esp_filter_weapons_accentColor01_label                              = ui_new_checkbox("VISUALS", "Player ESP", "Weapons (Color Invis.)")
    local b_esp_filter_weapons_accentColor01_colorPicker                        = ui_new_color_picker("VISUALS", "Player ESP", "Weapons (Color Invis.)", 127, 127, 127, 63)
    ui.set_callback(b_esp_filter_weapons_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_weapons_accentColor01_colorPicker);
        b_esp_filter_weapons_accentColor01 = {r, g, b , a}
    end)
    local b_esp_filter_weapons_accentColor02_label                              = ui_new_checkbox("VISUALS", "Player ESP", "Weapons (Color Vis.)")
    local b_esp_filter_weapons_accentColor02_colorPicker                        = ui_new_color_picker("VISUALS", "Player ESP", "Weapons (Color Vis.)", 255, 255, 255, 63)
    ui.set_callback(b_esp_filter_weapons_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_weapons_accentColor02_colorPicker);
        b_esp_filter_weapons_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_mapObjective_accentColor01                                     = {} -- Autofilled using func_extesp_rainbowise function
    b_esp_filter_mapObjective_accentColor02                                     = {} -- Autofilled using func_extesp_rainbowise function

    b_esp_filter_other_accentColor01                        = {127, 127, 127, 63}
    b_esp_filter_other_accentColor02                        = {255, 255, 255, 63}
    b_esp_filter_other_accentColor01_label                  = ui_new_checkbox("VISUALS", "Player ESP", "Other (Color Invis.)")
    b_esp_filter_other_accentColor01_colorPicker            = ui_new_color_picker("VISUALS", "Player ESP", "Other (Color Invis.)", 127, 127, 127, 63)
    ui.set_callback(b_esp_filter_other_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_other_accentColor01_colorPicker);
        b_esp_filter_other_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_other_accentColor02_label                  = ui_new_checkbox("VISUALS", "Player ESP", "Other (Color Vis.)")
    b_esp_filter_other_accentColor02_colorPicker            = ui_new_color_picker("VISUALS", "Player ESP", "Other (Color Vis.)", 255, 255, 255, 63)
    ui.set_callback(b_esp_filter_other_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_other_accentColor02_colorPicker);
        b_esp_filter_other_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stHEG_accentColor01             = {170, 0, 0, 255}
    b_esp_filter_projectile_stHEG_accentColor02             = {255, 0, 0, 255}
    b_esp_filter_projectile_stHEG_accentColor01_label       = ui_new_checkbox("VISUALS", "Player ESP", "Projectile HEG (Color Invis.)")
    b_esp_filter_projectile_stHEG_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile HEG (Color Invis.)", 170, 0, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stHEG_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stHEG_accentColor01_colorPicker);
        b_esp_filter_projectile_stHEG_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stHEG_accentColor02_label       = ui_new_checkbox("VISUALS", "Player ESP", "Projectile HEG (Color Vis.)")
    b_esp_filter_projectile_stHEG_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile HEG (Color Vis.)", 255, 0, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stHEG_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stHEG_accentColor02_colorPicker);
        b_esp_filter_projectile_stHEG_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stTAG_accentColor01             = {113, 0, 170, 255}
    b_esp_filter_projectile_stTAG_accentColor02             = {170, 0, 255, 255}
    b_esp_filter_projectile_stTAG_accentColor01_label       = ui_new_checkbox("VISUALS", "Player ESP", "Projectile TAG (Color Invis.)")
    b_esp_filter_projectile_stTAG_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile TAG (Color Invis.)", 113, 0, 170, 255)
    ui.set_callback(b_esp_filter_projectile_stTAG_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stTAG_accentColor01_colorPicker);
        b_esp_filter_projectile_stTAG_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stTAG_accentColor02_label       = ui_new_checkbox("VISUALS", "Player ESP", "Projectile TAG (Color Vis.)")
    b_esp_filter_projectile_stTAG_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile TAG (Color Vis.)", 170, 0, 255, 255)
    ui.set_callback(b_esp_filter_projectile_stTAG_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stTAG_accentColor02_colorPicker);
        b_esp_filter_projectile_stTAG_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stSmokeG_accentColor01          = {0, 170, 0, 255}
    b_esp_filter_projectile_stSmokeG_accentColor02          = {0, 255, 0, 255}
    b_esp_filter_projectile_stSmokeG_accentColor01_label    = ui_new_checkbox("VISUALS", "Player ESP", "Projectile SmokeG (Color Invis.)")
    b_esp_filter_projectile_stSmokeG_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile SmokeG (Color Invis.)", 0, 170, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stSmokeG_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stSmokeG_accentColor01_colorPicker);
        b_esp_filter_projectile_stSmokeG_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stSmokeG_accentColor02_label    = ui_new_checkbox("VISUALS", "Player ESP", "Projectile SmokeG (Color Vis.)")
    b_esp_filter_projectile_stSmokeG_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile SmokeG (Color Vis.)", 0, 255, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stSmokeG_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stSmokeG_accentColor02_colorPicker);
        b_esp_filter_projectile_stSmokeG_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stMolotov_accentColor01         = {170, 113, 0, 255}
    b_esp_filter_projectile_stMolotov_accentColor02         = {255, 170, 0, 255}
    b_esp_filter_projectile_stMolotov_accentColor01_label   = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Molotov/Incendiary (Color Invis.)")
    b_esp_filter_projectile_stMolotov_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Molotov/Incendiary (Color Invis.)", 170, 113, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stMolotov_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stMolotov_accentColor01_colorPicker);
        b_esp_filter_projectile_stMolotov_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stMolotov_accentColor02_label   = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Molotov/Incendiary (Color Vis.)")
    b_esp_filter_projectile_stMolotov_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Molotov/Incendiary (Color Vis.)", 255, 170, 0, 255)
    ui.set_callback(b_esp_filter_projectile_stMolotov_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stMolotov_accentColor02_colorPicker);
        b_esp_filter_projectile_stMolotov_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stFlashbang_accentColor01       = {170, 170, 170, 255}
    b_esp_filter_projectile_stFlashbang_accentColor02       = {255, 255, 255, 255}
    b_esp_filter_projectile_stFlashbang_accentColor01_label = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Flashbang (Color Invis.)")
    b_esp_filter_projectile_stFlashbang_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Flashbang (Color Invis.)", 170, 170, 170, 255)
    ui.set_callback(b_esp_filter_projectile_stFlashbang_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stFlashbang_accentColor01_colorPicker);
        b_esp_filter_projectile_stFlashbang_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stFlashbang_accentColor02_label = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Flashbang (Color Vis.)")
    b_esp_filter_projectile_stFlashbang_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Flashbang (Color Vis.)", 255, 255, 255, 255)
    ui.set_callback(b_esp_filter_projectile_stFlashbang_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stFlashbang_accentColor02_colorPicker);
        b_esp_filter_projectile_stFlashbang_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stDecoy_accentColor01           = {113, 113, 113, 255}
    b_esp_filter_projectile_stDecoy_accentColor02           = {170, 170, 170, 255}
    b_esp_filter_projectile_stDecoy_accentColor01_label     = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Decoy (Color Invis.)")
    b_esp_filter_projectile_stDecoy_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Decoy (Color Invis.)", 113, 113, 113, 255)
    ui.set_callback(b_esp_filter_projectile_stDecoy_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stDecoy_accentColor01_colorPicker);
        b_esp_filter_projectile_stDecoy_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stDecoy_accentColor02_label     = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Decoy (Color Vis.)")
    b_esp_filter_projectile_stDecoy_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Decoy (Color Vis.)", 170, 170, 170, 255)
    ui.set_callback(b_esp_filter_projectile_stDecoy_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stDecoy_accentColor02_colorPicker);
        b_esp_filter_projectile_stDecoy_accentColor02 = {r, g, b , a}
    end)

    b_esp_filter_projectile_stSnowball_accentColor01       = {113, 170, 170, 255}
    b_esp_filter_projectile_stSnowball_accentColor02       = {170, 255, 255, 255}
    b_esp_filter_projectile_stSnowball_accentColor01_label = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Snowball (Color Invis.)")
    b_esp_filter_projectile_stSnowball_accentColor01_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Snowball (Color Invis.)", 113, 170, 170, 255)
    ui.set_callback(b_esp_filter_projectile_stSnowball_accentColor01_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stSnowball_accentColor01_colorPicker);
        b_esp_filter_projectile_stSnowball_accentColor01 = {r, g, b , a}
    end)
    b_esp_filter_projectile_stSnowball_accentColor02_label = ui_new_checkbox("VISUALS", "Player ESP", "Projectile Snowball (Color Vis.)")
    b_esp_filter_projectile_stSnowball_accentColor02_colorPicker = ui_new_color_picker("VISUALS", "Player ESP", "Projectile Snowball (Color Vis.)", 170, 255, 255, 255)
    ui.set_callback(b_esp_filter_projectile_stSnowball_accentColor02_colorPicker, function ()
        local r, g, b, a = ui_get(b_esp_filter_projectile_stSnowball_accentColor02_colorPicker);
        b_esp_filter_projectile_stSnowball_accentColor02 = {r, g, b , a}
    end)


-- [Calculated configuration] ----------------------------------------------------------------------------------------------------------------------------------

    i_esp_drawScreenWidth,
    i_esp_drawScreenHeight                                  = client.screen_size()

-- [Functions] -------------------------------------------------------------------------------------------------------------------------------------------------

local func_extesp_clampToViewport = function(mediaScreenWidth, mediaScreenHeight, mediaScreenAnchorX, mediaScreenAnchorY, entityScreenPosX, entityScreenPosY, entityScreenPosPadding)
    if entityScreenPosX <= 0 + entityScreenPosPadding then
        local X_XC_DELTA = math_abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math_abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_YX_RATIO = Y_YC_DELTA / X_XC_DELTA;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math_floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math_floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        entityScreenPosX = 0 + entityScreenPosPadding;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math_floor(entityScreenPosX * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math_floor(entityScreenPosX * DELTA_YX_RATIO);
        end
    end

    if entityScreenPosX >= mediaScreenWidth - entityScreenPosPadding then
        local X_XC_DELTA = math_abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math_abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_YX_RATIO = -(Y_YC_DELTA / X_XC_DELTA);
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math_floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math_floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        entityScreenPosX = mediaScreenWidth - entityScreenPosPadding;
        if entityScreenPosY > mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY - math_floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
        if entityScreenPosY < mediaScreenAnchorY then
            entityScreenPosY = entityScreenPosY + math_floor((entityScreenPosX - mediaScreenWidth) * DELTA_YX_RATIO);
        end
    end

    if entityScreenPosY <= 0 + entityScreenPosPadding then
        local X_XC_DELTA = math_abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math_abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_XY_RATIO = X_XC_DELTA / Y_YC_DELTA;
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math_floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math_floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        entityScreenPosY = (0 + entityScreenPosPadding);
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math_floor(entityScreenPosY * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math_floor(entityScreenPosY * DELTA_XY_RATIO);
        end
    end

    if entityScreenPosY >= mediaScreenHeight - entityScreenPosPadding then
        local X_XC_DELTA = math_abs(entityScreenPosX - mediaScreenAnchorX);
        local Y_YC_DELTA = math_abs(entityScreenPosY - mediaScreenAnchorY);
        local DELTA_XY_RATIO = -(X_XC_DELTA / Y_YC_DELTA);
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math_floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math_floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        entityScreenPosY = mediaScreenHeight - entityScreenPosPadding;
        if entityScreenPosX > mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX - math_floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
        if entityScreenPosX < mediaScreenAnchorX then
            entityScreenPosX = entityScreenPosX + math_floor((entityScreenPosY - mediaScreenHeight) * DELTA_XY_RATIO);
        end
    end

    return entityScreenPosX, entityScreenPosY;
end
local func_extesp_getClampToViewport = function(mediaScreenWidth, mediaScreenHeight, entityScreenPosX, entityScreenPosY, entityScreenPosPadding)
    if entityScreenPosX <= 0 + entityScreenPosPadding then
        return false
    elseif entityScreenPosX >= mediaScreenWidth - entityScreenPosPadding then
        return false
    elseif entityScreenPosY <= 0 + entityScreenPosPadding then
        return false
    elseif entityScreenPosY >= mediaScreenHeight - entityScreenPosPadding then
        return false
    end
    return true
end
local func_extesp_rainbowise = function(a,b,c,d,e,f,g)local h,i,j=math_cos(a*(f+g))*b+math_floor(b/2),math_cos(a*(f+g)+2*math.pi/3*c)*b+math_floor(b/2),math_cos(a*(f+g)-2*math.pi/3*c)*b+math_floor(b/2)if h<d then h=d end;if j<d then j=d end;if i<d then i=d end;if h>e then h=e end;if j>e then j=e end;if i>e then i=e end;return {h,i,j} end
local func_extesp_rotate3D = function(pitch, yaw, roll, nodes)
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

    local rot = maf.quat(x, y, z, w)
    vec:rotate(rot)
    nodes[i] = vec
    end
end
local table_contains_str = function(table, str)
    for _, v in ipairs(table) do
        if v == str then
            return true
        end
    end
    return false
end
local func_extesp_snapline = function(entIndex_serverEntCAny, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()

    local i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = renderer_world_to_screen(vec_serverEntCAny_WorldPos.x, vec_serverEntCAny_WorldPos.y, vec_serverEntCAny_WorldPos.z)

    if i_serverEntCAny_ScreenPosX ~= nil and i_serverEntCAny_ScreenPosY ~= nil then
        i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = func_extesp_clampToViewport(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, ui_get(ref_extesp_padding))

        if obj_serverEntCAny:is_player() == true then
            obj_serverEntCAny = Player(entIndex_serverEntCAny)
            vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_hitbox_pos("head_0")
        end

        b_serverEntCAny_IsVisible = obj_localEntCCSPlayer:can_see_point(vec_serverEntCAny_WorldPos)

        if ui_get(ref_extesp_originPoint) then
            renderer_rectangle(i_serverEntCAny_ScreenPosX - 3, i_serverEntCAny_ScreenPosY - 3, 7, 7, 0, 0, 0, 127)

            if b_serverEntCAny_IsVisible == true then
                renderer_rectangle(i_serverEntCAny_ScreenPosX - 2, i_serverEntCAny_ScreenPosY - 2, 5, 5, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
            else
                renderer_rectangle(i_serverEntCAny_ScreenPosX - 2, i_serverEntCAny_ScreenPosY - 2, 5, 5, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
            end
        end

        if ui_get(ref_extesp_snapline) then
            if b_serverEntCAny_IsVisible == true then
                renderer_line(i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_anchorPosX, i_esp_anchorPosY, accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4])
            else
                renderer_line(i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, i_esp_anchorPosX, i_esp_anchorPosY, accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4])
            end
        end
    end
end
local func_extesp_boundingBoxStatic = function(entIndex_serverEntCAny, accentColor01, accentColor02)
    if not (ui_get(ref_extesp_boundingBox) == "Off") then
        local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
        local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

        local vec_serverEntCAny_WorldPos = {x, y, z}
        local vec_serverEntCAny_WorldAng = {pitch, yaw, roll}

        vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()
        vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldAng.roll = entity_get_prop(entIndex_serverEntCAny, "m_angRotation", array_index)
        local vec_serverEntCAny_WorldPosVecMins = obj_serverEntCAny:get_vec_mins()
        local vec_serverEntCAny_WorldPosVecMaxs = obj_serverEntCAny:get_vec_maxs()

        local vec_serverEntCAny_WorldPosP1P8 = {
            [1] = {
                x = vec_serverEntCAny_WorldPosVecMins.x,
                y = vec_serverEntCAny_WorldPosVecMins.y,
                z = vec_serverEntCAny_WorldPosVecMins.z,
            },
            [2] = {
                x = vec_serverEntCAny_WorldPosVecMaxs.x,
                y = vec_serverEntCAny_WorldPosVecMins.y,
                z = vec_serverEntCAny_WorldPosVecMins.z,
            },
            [3] = {
                x = vec_serverEntCAny_WorldPosVecMaxs.x,
                y = vec_serverEntCAny_WorldPosVecMaxs.y,
                z = vec_serverEntCAny_WorldPosVecMins.z,
            },
            [4] = {
                x = vec_serverEntCAny_WorldPosVecMins.x,
                y = vec_serverEntCAny_WorldPosVecMaxs.y,
                z = vec_serverEntCAny_WorldPosVecMins.z,
            },
            [5] = {
                x = vec_serverEntCAny_WorldPosVecMins.x,
                y = vec_serverEntCAny_WorldPosVecMins.y,
                z = vec_serverEntCAny_WorldPosVecMaxs.z,
            },
            [6] = {
                x = vec_serverEntCAny_WorldPosVecMaxs.x,
                y = vec_serverEntCAny_WorldPosVecMins.y,
                z = vec_serverEntCAny_WorldPosVecMaxs.z,
            },
            [7] = {
                x = vec_serverEntCAny_WorldPosVecMaxs.x,
                y = vec_serverEntCAny_WorldPosVecMaxs.y,
                z = vec_serverEntCAny_WorldPosVecMaxs.z,
            },
            [8] = {
                x = vec_serverEntCAny_WorldPosVecMins.x,
                y = vec_serverEntCAny_WorldPosVecMaxs.y,
                z = vec_serverEntCAny_WorldPosVecMaxs.z,
            },
        }

        func_extesp_rotate3D(vec_serverEntCAny_WorldAng.roll, vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldPosP1P8)

        vec_serverEntCAny_WorldPosP1P8 = {
            [1] = {
                x = vec_serverEntCAny_WorldPosP1P8[1].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[1].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[1].z + vec_serverEntCAny_WorldPos.z,
            },
            [2] = {
                x = vec_serverEntCAny_WorldPosP1P8[2].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[2].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[2].z + vec_serverEntCAny_WorldPos.z,
            },
            [3] = {
                x = vec_serverEntCAny_WorldPosP1P8[3].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[3].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[3].z + vec_serverEntCAny_WorldPos.z,
            },
            [4] = {
                x = vec_serverEntCAny_WorldPosP1P8[4].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[4].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[4].z + vec_serverEntCAny_WorldPos.z,
            },
            [5] = {
                x = vec_serverEntCAny_WorldPosP1P8[5].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[5].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[5].z + vec_serverEntCAny_WorldPos.z,
            },
            [6] = {
                x = vec_serverEntCAny_WorldPosP1P8[6].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[6].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[6].z + vec_serverEntCAny_WorldPos.z,
            },
            [7] = {
                x = vec_serverEntCAny_WorldPosP1P8[7].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[7].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[7].z + vec_serverEntCAny_WorldPos.z,
            },
            [8] = {
                x = vec_serverEntCAny_WorldPosP1P8[8].x + vec_serverEntCAny_WorldPos.x,
                y = vec_serverEntCAny_WorldPosP1P8[8].y + vec_serverEntCAny_WorldPos.y,
                z = vec_serverEntCAny_WorldPosP1P8[8].z + vec_serverEntCAny_WorldPos.z,
            },
        }

        local renderer_world_to_screen_asTable = function(Wx, Wy, Wz)
            local returnObj = {x, y}
            returnObj.x, returnObj.y = renderer_world_to_screen(Wx, Wy, Wz)
            return returnObj
        end

        local vec_serverEntCAny_ScreenPosP1P8 = {
            [1] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[1].x, vec_serverEntCAny_WorldPosP1P8[1].y, vec_serverEntCAny_WorldPosP1P8[1].z),
            [2] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[2].x, vec_serverEntCAny_WorldPosP1P8[2].y, vec_serverEntCAny_WorldPosP1P8[2].z),
            [3] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[3].x, vec_serverEntCAny_WorldPosP1P8[3].y, vec_serverEntCAny_WorldPosP1P8[3].z),
            [4] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[4].x, vec_serverEntCAny_WorldPosP1P8[4].y, vec_serverEntCAny_WorldPosP1P8[4].z),
            [5] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[5].x, vec_serverEntCAny_WorldPosP1P8[5].y, vec_serverEntCAny_WorldPosP1P8[5].z),
            [6] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[6].x, vec_serverEntCAny_WorldPosP1P8[6].y, vec_serverEntCAny_WorldPosP1P8[6].z),
            [7] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[7].x, vec_serverEntCAny_WorldPosP1P8[7].y, vec_serverEntCAny_WorldPosP1P8[7].z),
            [8] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[8].x, vec_serverEntCAny_WorldPosP1P8[8].y, vec_serverEntCAny_WorldPosP1P8[8].z),
        }

        for i = 1, #vec_serverEntCAny_ScreenPosP1P8 do
            if vec_serverEntCAny_ScreenPosP1P8[i].x == nil or vec_serverEntCAny_ScreenPosP1P8[i].y == nil then
                return
            end
        end

        if obj_serverEntCAny:is_player() == true then
            obj_serverEntCAny = Player(entIndex_serverEntCAny)
            vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_hitbox_pos("head_0")
        end

        b_serverEntCAny_IsVisible = false

        b_serverEntCAny_IsVisible = obj_localEntCCSPlayer:can_see_point(vec_serverEntCAny_WorldPos)

        if ui_get(ref_extesp_boundingBox) == "On (Static 3D)" then
            local Color = {r, g, b, a};

            if b_serverEntCAny_IsVisible == true then
                Color.r, Color.g, Color.b, Color.a = accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4]
            else
                Color.r, Color.g, Color.b, Color.a = accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4]
            end

            -- Bottom
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[1].x, vec_serverEntCAny_ScreenPosP1P8[1].y, vec_serverEntCAny_ScreenPosP1P8[2].x, vec_serverEntCAny_ScreenPosP1P8[2].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[2].x, vec_serverEntCAny_ScreenPosP1P8[2].y, vec_serverEntCAny_ScreenPosP1P8[3].x, vec_serverEntCAny_ScreenPosP1P8[3].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[3].x, vec_serverEntCAny_ScreenPosP1P8[3].y, vec_serverEntCAny_ScreenPosP1P8[4].x, vec_serverEntCAny_ScreenPosP1P8[4].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[4].x, vec_serverEntCAny_ScreenPosP1P8[4].y, vec_serverEntCAny_ScreenPosP1P8[1].x, vec_serverEntCAny_ScreenPosP1P8[1].y, Color.r, Color.g, Color.b, Color.a)
            -- Top
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[5].x, vec_serverEntCAny_ScreenPosP1P8[5].y, vec_serverEntCAny_ScreenPosP1P8[6].x, vec_serverEntCAny_ScreenPosP1P8[6].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[6].x, vec_serverEntCAny_ScreenPosP1P8[6].y, vec_serverEntCAny_ScreenPosP1P8[7].x, vec_serverEntCAny_ScreenPosP1P8[7].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[7].x, vec_serverEntCAny_ScreenPosP1P8[7].y, vec_serverEntCAny_ScreenPosP1P8[8].x, vec_serverEntCAny_ScreenPosP1P8[8].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[8].x, vec_serverEntCAny_ScreenPosP1P8[8].y, vec_serverEntCAny_ScreenPosP1P8[5].x, vec_serverEntCAny_ScreenPosP1P8[5].y, Color.r, Color.g, Color.b, Color.a)
            -- Sides
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[1].x, vec_serverEntCAny_ScreenPosP1P8[1].y, vec_serverEntCAny_ScreenPosP1P8[5].x, vec_serverEntCAny_ScreenPosP1P8[5].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[2].x, vec_serverEntCAny_ScreenPosP1P8[2].y, vec_serverEntCAny_ScreenPosP1P8[6].x, vec_serverEntCAny_ScreenPosP1P8[6].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[3].x, vec_serverEntCAny_ScreenPosP1P8[3].y, vec_serverEntCAny_ScreenPosP1P8[7].x, vec_serverEntCAny_ScreenPosP1P8[7].y, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosP1P8[4].x, vec_serverEntCAny_ScreenPosP1P8[4].y, vec_serverEntCAny_ScreenPosP1P8[8].x, vec_serverEntCAny_ScreenPosP1P8[8].y, Color.r, Color.g, Color.b, Color.a)
        end

        if ui_get(ref_extesp_boundingBox) == "On (Static 2D)" then
            local vec_serverEntCAny_ScreenPosOffsetX = 0;
            local vec_serverEntCAny_ScreenPosOffsetY = 0;
            local vec_serverEntCAny_ScreenPosStartX = i_esp_drawScreenWidth;
            local vec_serverEntCAny_ScreenPosStartY = i_esp_drawScreenHeight;

            for i = 1, 8 do
                for j = i + 1, 8 do
                    vec_serverEntCAny_ScreenPosOffsetX = math_max(vec_serverEntCAny_ScreenPosOffsetX, math_abs(vec_serverEntCAny_ScreenPosP1P8[i].x - vec_serverEntCAny_ScreenPosP1P8[j].x))
                    vec_serverEntCAny_ScreenPosOffsetY = math_max(vec_serverEntCAny_ScreenPosOffsetY, math_abs(vec_serverEntCAny_ScreenPosP1P8[i].y - vec_serverEntCAny_ScreenPosP1P8[j].y))
                end
                vec_serverEntCAny_ScreenPosStartX = math_min(vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosP1P8[i].x)
                vec_serverEntCAny_ScreenPosStartY = math_min(vec_serverEntCAny_ScreenPosStartY, vec_serverEntCAny_ScreenPosP1P8[i].y)
            end

            local Color = {r, g, b, a};

            if b_serverEntCAny_IsVisible == true then
                Color.r, Color.g, Color.b, Color.a = accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4]
            else
                Color.r, Color.g, Color.b, Color.a = accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4]
            end

            -- Bottom
            renderer_line(vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosStartY + vec_serverEntCAny_ScreenPosOffsetY, vec_serverEntCAny_ScreenPosStartX + vec_serverEntCAny_ScreenPosOffsetX, vec_serverEntCAny_ScreenPosStartY + vec_serverEntCAny_ScreenPosOffsetY, Color.r, Color.g, Color.b, Color.a)
            -- Top
            renderer_line(vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosStartY, vec_serverEntCAny_ScreenPosStartX + vec_serverEntCAny_ScreenPosOffsetX, vec_serverEntCAny_ScreenPosStartY, Color.r, Color.g, Color.b, Color.a)
            -- Sides
            renderer_line(vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosStartY, vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosStartY + vec_serverEntCAny_ScreenPosOffsetY, Color.r, Color.g, Color.b, Color.a)
            renderer_line(vec_serverEntCAny_ScreenPosStartX + vec_serverEntCAny_ScreenPosOffsetX, vec_serverEntCAny_ScreenPosStartY, vec_serverEntCAny_ScreenPosStartX + vec_serverEntCAny_ScreenPosOffsetX, vec_serverEntCAny_ScreenPosStartY + vec_serverEntCAny_ScreenPosOffsetY, Color.r, Color.g, Color.b, Color.a)
        end
    end
end
local func_extesp_getBoundingBoxStatic = function(entIndex_serverEntCAny)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)

    local vec_serverEntCAny_WorldPos = {x, y, z}
    local vec_serverEntCAny_WorldAng = {pitch, yaw, roll}

    vec_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()
    vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldAng.roll = entity_get_prop(entIndex_serverEntCAny, "m_angRotation", array_index)

    local vec_serverEntCAny_WorldPosVecMins = obj_serverEntCAny:get_vec_mins()
    local vec_serverEntCAny_WorldPosVecMaxs = obj_serverEntCAny:get_vec_maxs()

    local vec_serverEntCAny_WorldPosP1P8 = {
        [1] = {
            x = vec_serverEntCAny_WorldPosVecMins.x,
            y = vec_serverEntCAny_WorldPosVecMins.y,
            z = vec_serverEntCAny_WorldPosVecMins.z,
        },
        [2] = {
            x = vec_serverEntCAny_WorldPosVecMaxs.x,
            y = vec_serverEntCAny_WorldPosVecMins.y,
            z = vec_serverEntCAny_WorldPosVecMins.z,
        },
        [3] = {
            x = vec_serverEntCAny_WorldPosVecMaxs.x,
            y = vec_serverEntCAny_WorldPosVecMaxs.y,
            z = vec_serverEntCAny_WorldPosVecMins.z,
        },
        [4] = {
            x = vec_serverEntCAny_WorldPosVecMins.x,
            y = vec_serverEntCAny_WorldPosVecMaxs.y,
            z = vec_serverEntCAny_WorldPosVecMins.z,
        },
        [5] = {
            x = vec_serverEntCAny_WorldPosVecMins.x,
            y = vec_serverEntCAny_WorldPosVecMins.y,
            z = vec_serverEntCAny_WorldPosVecMaxs.z,
        },
        [6] = {
            x = vec_serverEntCAny_WorldPosVecMaxs.x,
            y = vec_serverEntCAny_WorldPosVecMins.y,
            z = vec_serverEntCAny_WorldPosVecMaxs.z,
        },
        [7] = {
            x = vec_serverEntCAny_WorldPosVecMaxs.x,
            y = vec_serverEntCAny_WorldPosVecMaxs.y,
            z = vec_serverEntCAny_WorldPosVecMaxs.z,
        },
        [8] = {
            x = vec_serverEntCAny_WorldPosVecMins.x,
            y = vec_serverEntCAny_WorldPosVecMaxs.y,
            z = vec_serverEntCAny_WorldPosVecMaxs.z,
        },
    }

    func_extesp_rotate3D(vec_serverEntCAny_WorldAng.roll, vec_serverEntCAny_WorldAng.pitch, vec_serverEntCAny_WorldAng.yaw, vec_serverEntCAny_WorldPosP1P8)

    vec_serverEntCAny_WorldPosP1P8 = {
        [1] = {
            x = vec_serverEntCAny_WorldPosP1P8[1].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[1].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[1].z + vec_serverEntCAny_WorldPos.z,
        },
        [2] = {
            x = vec_serverEntCAny_WorldPosP1P8[2].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[2].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[2].z + vec_serverEntCAny_WorldPos.z,
        },
        [3] = {
            x = vec_serverEntCAny_WorldPosP1P8[3].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[3].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[3].z + vec_serverEntCAny_WorldPos.z,
        },
        [4] = {
            x = vec_serverEntCAny_WorldPosP1P8[4].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[4].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[4].z + vec_serverEntCAny_WorldPos.z,
        },
        [5] = {
            x = vec_serverEntCAny_WorldPosP1P8[5].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[5].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[5].z + vec_serverEntCAny_WorldPos.z,
        },
        [6] = {
            x = vec_serverEntCAny_WorldPosP1P8[6].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[6].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[6].z + vec_serverEntCAny_WorldPos.z,
        },
        [7] = {
            x = vec_serverEntCAny_WorldPosP1P8[7].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[7].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[7].z + vec_serverEntCAny_WorldPos.z,
        },
        [8] = {
            x = vec_serverEntCAny_WorldPosP1P8[8].x + vec_serverEntCAny_WorldPos.x,
            y = vec_serverEntCAny_WorldPosP1P8[8].y + vec_serverEntCAny_WorldPos.y,
            z = vec_serverEntCAny_WorldPosP1P8[8].z + vec_serverEntCAny_WorldPos.z,
        },
    }

    local renderer_world_to_screen_asTable = function(Wx, Wy, Wz)
        local returnObj = {x, y}
        returnObj.x, returnObj.y = renderer_world_to_screen(Wx, Wy, Wz)
        return returnObj
    end

    local vec_serverEntCAny_ScreenPosP1P8 = {
        [1] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[1].x, vec_serverEntCAny_WorldPosP1P8[1].y, vec_serverEntCAny_WorldPosP1P8[1].z),
        [2] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[2].x, vec_serverEntCAny_WorldPosP1P8[2].y, vec_serverEntCAny_WorldPosP1P8[2].z),
        [3] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[3].x, vec_serverEntCAny_WorldPosP1P8[3].y, vec_serverEntCAny_WorldPosP1P8[3].z),
        [4] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[4].x, vec_serverEntCAny_WorldPosP1P8[4].y, vec_serverEntCAny_WorldPosP1P8[4].z),
        [5] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[5].x, vec_serverEntCAny_WorldPosP1P8[5].y, vec_serverEntCAny_WorldPosP1P8[5].z),
        [6] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[6].x, vec_serverEntCAny_WorldPosP1P8[6].y, vec_serverEntCAny_WorldPosP1P8[6].z),
        [7] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[7].x, vec_serverEntCAny_WorldPosP1P8[7].y, vec_serverEntCAny_WorldPosP1P8[7].z),
        [8] = renderer_world_to_screen_asTable(vec_serverEntCAny_WorldPosP1P8[8].x, vec_serverEntCAny_WorldPosP1P8[8].y, vec_serverEntCAny_WorldPosP1P8[8].z),
    }

    local returnObj = {x, y, width, height, onScreen}

    for i = 1, #vec_serverEntCAny_ScreenPosP1P8 do
        if vec_serverEntCAny_ScreenPosP1P8[i].x == nil or vec_serverEntCAny_ScreenPosP1P8[i].y == nil then
            returnObj.onScreen = false
            return returnObj
        end
    end

    local vec_serverEntCAny_ScreenPosOffsetX = 0;
    local vec_serverEntCAny_ScreenPosOffsetY = 0;
    local vec_serverEntCAny_ScreenPosStartX = i_esp_drawScreenWidth;
    local vec_serverEntCAny_ScreenPosStartY = i_esp_drawScreenHeight;

    for i = 1, 8 do
        for j = i + 1, 8 do
            vec_serverEntCAny_ScreenPosOffsetX = math_max(vec_serverEntCAny_ScreenPosOffsetX, math_abs(vec_serverEntCAny_ScreenPosP1P8[i].x - vec_serverEntCAny_ScreenPosP1P8[j].x))
            vec_serverEntCAny_ScreenPosOffsetY = math_max(vec_serverEntCAny_ScreenPosOffsetY, math_abs(vec_serverEntCAny_ScreenPosP1P8[i].y - vec_serverEntCAny_ScreenPosP1P8[j].y))
        end
        vec_serverEntCAny_ScreenPosStartX = math_min(vec_serverEntCAny_ScreenPosStartX, vec_serverEntCAny_ScreenPosP1P8[i].x)
        vec_serverEntCAny_ScreenPosStartY = math_min(vec_serverEntCAny_ScreenPosStartY, vec_serverEntCAny_ScreenPosP1P8[i].y)
    end

    returnObj.x = vec_serverEntCAny_ScreenPosStartX
    returnObj.y = vec_serverEntCAny_ScreenPosStartY
    returnObj.width = vec_serverEntCAny_ScreenPosOffsetX
    returnObj.height = vec_serverEntCAny_ScreenPosOffsetY
    returnObj.onScreen = true

    return returnObj
end
local func_extesp_skeleton = function(entIndex_serverEntCCSPlayer, accentColor01, accentColor02)
    if ui_get(ref_extesp_skeleton) then
        local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)
        local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

        local renderer_world_to_screen_asTable = function(Wx, Wy, Wz)
            local returnObj = {x, y}
            returnObj.x, returnObj.y = renderer_world_to_screen(Wx, Wy, Wz)
            return returnObj
        end

        local vec_serverEntCCSPlayer_ScreenPosTable = {}

        for i = 0, 18 do
            local vec_serverEntCCSPlayer_WorldPos = obj_serverEntCCSPlayer:get_hitbox_pos(i)
            local vec_serverEntCCSPlayer_ScreenPos = renderer_world_to_screen_asTable(vec_serverEntCCSPlayer_WorldPos.x, vec_serverEntCCSPlayer_WorldPos.y, vec_serverEntCCSPlayer_WorldPos.z)

            table.insert(vec_serverEntCCSPlayer_ScreenPosTable, vec_serverEntCCSPlayer_ScreenPos)
        end

        for i = 1, 19 do
            if vec_serverEntCCSPlayer_ScreenPosTable[i].x == nil or vec_serverEntCCSPlayer_ScreenPosTable[i].y == nil then
                return
            end
        end

        b_serverEntCCSPlayer_IsVisible = false

        b_serverEntCCSPlayer_IsVisible = obj_localEntCCSPlayer:can_see_point(obj_serverEntCCSPlayer:get_hitbox_pos("head_0"))

        local Color = {r, g, b, a};

        if b_serverEntCCSPlayer_IsVisible == true then
            Color.r, Color.g, Color.b, Color.a = accentColor02[1], accentColor02[2], accentColor02[3], accentColor02[4]
        else
            Color.r, Color.g, Color.b, Color.a = accentColor01[1], accentColor01[2], accentColor01[3], accentColor01[4]
        end

        -- Middle
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[1].x, vec_serverEntCCSPlayer_ScreenPosTable[1].y, vec_serverEntCCSPlayer_ScreenPosTable[2].x, vec_serverEntCCSPlayer_ScreenPosTable[2].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[2].x, vec_serverEntCCSPlayer_ScreenPosTable[2].y, vec_serverEntCCSPlayer_ScreenPosTable[7].x, vec_serverEntCCSPlayer_ScreenPosTable[7].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[7].x, vec_serverEntCCSPlayer_ScreenPosTable[7].y, vec_serverEntCCSPlayer_ScreenPosTable[6].x, vec_serverEntCCSPlayer_ScreenPosTable[6].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[6].x, vec_serverEntCCSPlayer_ScreenPosTable[6].y, vec_serverEntCCSPlayer_ScreenPosTable[5].x, vec_serverEntCCSPlayer_ScreenPosTable[5].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[5].x, vec_serverEntCCSPlayer_ScreenPosTable[5].y, vec_serverEntCCSPlayer_ScreenPosTable[4].x, vec_serverEntCCSPlayer_ScreenPosTable[4].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[4].x, vec_serverEntCCSPlayer_ScreenPosTable[4].y, vec_serverEntCCSPlayer_ScreenPosTable[3].x, vec_serverEntCCSPlayer_ScreenPosTable[3].y, Color.r, Color.g, Color.b, Color.a)

        -- Arms

        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[7].x, vec_serverEntCCSPlayer_ScreenPosTable[7].y, vec_serverEntCCSPlayer_ScreenPosTable[16].x, vec_serverEntCCSPlayer_ScreenPosTable[16].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[16].x, vec_serverEntCCSPlayer_ScreenPosTable[16].y, vec_serverEntCCSPlayer_ScreenPosTable[17].x, vec_serverEntCCSPlayer_ScreenPosTable[17].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[17].x, vec_serverEntCCSPlayer_ScreenPosTable[17].y, vec_serverEntCCSPlayer_ScreenPosTable[14].x, vec_serverEntCCSPlayer_ScreenPosTable[14].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[7].x, vec_serverEntCCSPlayer_ScreenPosTable[7].y, vec_serverEntCCSPlayer_ScreenPosTable[18].x, vec_serverEntCCSPlayer_ScreenPosTable[18].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[18].x, vec_serverEntCCSPlayer_ScreenPosTable[18].y, vec_serverEntCCSPlayer_ScreenPosTable[19].x, vec_serverEntCCSPlayer_ScreenPosTable[19].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[19].x, vec_serverEntCCSPlayer_ScreenPosTable[19].y, vec_serverEntCCSPlayer_ScreenPosTable[15].x, vec_serverEntCCSPlayer_ScreenPosTable[15].y, Color.r, Color.g, Color.b, Color.a)

        -- Legs
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[3].x, vec_serverEntCCSPlayer_ScreenPosTable[3].y, vec_serverEntCCSPlayer_ScreenPosTable[8].x, vec_serverEntCCSPlayer_ScreenPosTable[8].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[3].x, vec_serverEntCCSPlayer_ScreenPosTable[3].y, vec_serverEntCCSPlayer_ScreenPosTable[9].x, vec_serverEntCCSPlayer_ScreenPosTable[9].y, Color.r, Color.g, Color.b, Color.a)

        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[8].x, vec_serverEntCCSPlayer_ScreenPosTable[8].y, vec_serverEntCCSPlayer_ScreenPosTable[10].x, vec_serverEntCCSPlayer_ScreenPosTable[10].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[10].x, vec_serverEntCCSPlayer_ScreenPosTable[10].y, vec_serverEntCCSPlayer_ScreenPosTable[12].x, vec_serverEntCCSPlayer_ScreenPosTable[12].y, Color.r, Color.g, Color.b, Color.a)

        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[9].x, vec_serverEntCCSPlayer_ScreenPosTable[9].y, vec_serverEntCCSPlayer_ScreenPosTable[11].x, vec_serverEntCCSPlayer_ScreenPosTable[11].y, Color.r, Color.g, Color.b, Color.a)
        renderer_line(vec_serverEntCCSPlayer_ScreenPosTable[11].x, vec_serverEntCCSPlayer_ScreenPosTable[11].y, vec_serverEntCCSPlayer_ScreenPosTable[13].x, vec_serverEntCCSPlayer_ScreenPosTable[13].y, Color.r, Color.g, Color.b, Color.a)
    end
end
local func_extesp_CCSPlayerInfo = function(entIndex_serverEntCCSPlayer, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCCSPlayer_WorldPos = obj_serverEntCCSPlayer:get_vec_origin()

    local i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY = renderer_world_to_screen(i_serverEntCCSPlayer_WorldPos.x, i_serverEntCCSPlayer_WorldPos.y, i_serverEntCCSPlayer_WorldPos.z)

    if i_serverEntCCSPlayer_ScreenPosX ~= nil and i_serverEntCCSPlayer_ScreenPosY ~= nil then
        if func_extesp_getClampToViewport(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY, ui_get(ref_extesp_padding)) == false then
            i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY = func_extesp_clampToViewport(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCCSPlayer_ScreenPosX, i_serverEntCCSPlayer_ScreenPosY, ui_get(ref_extesp_padding))

            local i_esp_draw_strOffset = 1
            --
            --
            --  Name
            --
            --
            if ui_get(ref_extesp_name) then
                local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer_measure_text("b", "Name: " .. obj_serverEntCCSPlayer:get_name())

                renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

                renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Name: " .. obj_serverEntCCSPlayer:get_name())

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Health
            --
            --
            if ui_get(ref_extesp_health) then
                local i_esp_draw_health_strSizeX, i_esp_draw_health_strSizeY = renderer_measure_text("b", "Health: " .. obj_serverEntCCSPlayer:get_health() .. "%")

                renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_health_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_health_strSizeY * i_esp_draw_strOffset, i_esp_draw_health_strSizeX + 8, i_esp_draw_health_strSizeY, 0, 0, 0, 127)

                renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_health_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_health_strSizeY * i_esp_draw_strOffset, 255 - 255 * obj_serverEntCCSPlayer:get_health() / 100, 255 * obj_serverEntCCSPlayer:get_health() / 100, 0, 255, "b", 0, "Health: " .. obj_serverEntCCSPlayer:get_health() .. "%")

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  Armor
            --
            --
            if ui_get(ref_extesp_armor) then
                if obj_serverEntCCSPlayer:playerresource():get_armor() > 0 then
                    local i_esp_draw_armor_strSizeX, i_esp_draw_armor_strSizeY = renderer_measure_text("b", "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_armor_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset, i_esp_draw_armor_strSizeX + 8, i_esp_draw_armor_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_armor_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 255, "b", 0, "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
            end
            --
            --
            --  Distance
            --
            --
            if ui_get(ref_extesp_distance) ~= "Off" then
                local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

                local value = math.sqrt((i_serverEntCCSPlayer_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCCSPlayer_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCCSPlayer_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
                local valueUnit = " u."

                if ui_get(ref_extesp_distance) == "Metric" then
                    value = value * 0.01905
                    valueUnit = " m."
                end

                if ui_get(ref_extesp_distance) == "Imperial" then
                    value = value * 0.075
                    valueUnit = " ft."
                end

                local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer_measure_text("b", "Distance: " .. string.format("%d", value) .. valueUnit)

                renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

                renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. valueUnit)

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end
            --
            --
            --  NAV Location
            --
            --
            if ui_get(ref_extesp_navlocation) then
                local str_esp_draw_navlocation = entity_get_prop(entIndex_serverEntCCSPlayer, "m_szLastPlaceName", array_index)

                local i_esp_draw_navlocation_strSizeX, i_esp_draw_navlocation_strSizeY = renderer_measure_text("b", "Location: " .. str_esp_draw_navlocation)

                renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_navlocation_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, i_esp_draw_navlocation_strSizeX + 8, i_esp_draw_navlocation_strSizeY, 0, 0, 0, 127)

                renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_navlocation_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Location: " .. str_esp_draw_navlocation)

                i_esp_draw_strOffset = i_esp_draw_strOffset + 1
            end

            --
            --
            --  Weapons
            --
            --
            if ui_get(ref_extesp_equipment) then
                i_esp_draw_strOffset = i_esp_draw_strOffset + 1

                local arr_esp_draw_weapons = obj_serverEntCCSPlayer:get_all_weapons()
                for i = 1, #arr_esp_draw_weapons do
                    local ent_esp_draw_weapon = arr_esp_draw_weapons[i]

                    local str_esp_draw_weapon = ""

                    if ui_get(ref_extesp_ammo) and not(ent_esp_draw_weapon:is_knife()) and ent_esp_draw_weapon:get_current_ammo() ~= nil and ent_esp_draw_weapon:get_max_ammo() ~= nil then
                        str_esp_draw_weapon = ent_esp_draw_weapon:get_name() .. " (" .. ent_esp_draw_weapon:get_current_ammo() .. "/" .. ent_esp_draw_weapon:get_max_ammo() .. ")"
                    else
                        str_esp_draw_weapon = ent_esp_draw_weapon:get_name()
                    end

                    local i_esp_draw_weapon_strSizeX, i_esp_draw_weapon_strSizeY = renderer_measure_text("b", str_esp_draw_weapon)

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, i_esp_draw_weapon_strSizeX + 8, i_esp_draw_weapon_strSizeY, 0, 0, 0, 127)

                    if ent_esp_draw_weapon:get_index() == obj_serverEntCCSPlayer:get_active_weapon():get_index() then
                        renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, str_esp_draw_weapon)
                    else
                        renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_weapon)
                    end

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
            end

            --
            --
            --  Player State
            --
            --
            if ui_get(ref_extesp_flags) then
                i_esp_draw_strOffset = i_esp_draw_strOffset + 1

                --
                --
                --  Is Scoped
                --
                --
                if obj_serverEntCCSPlayer:is_scoped() then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Scoped")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, "Scoped")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Is Flashed
                --
                --
                if obj_serverEntCCSPlayer:is_flashed() then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Flashed")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 193, 240, 255, 255, "b", 0, "Flashed")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Has Bomb
                --
                --
                if obj_serverEntCCSPlayer:has_bomb() then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Bombcarrier")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 127, 0, 255, "b", 0, "Bombcarrier")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Has Defuser
                --
                --
                if obj_serverEntCCSPlayer:has_defuser() then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Has Kit")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 0, 127, 255, 255, "b", 0, "Has Kit")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Is In Air
                --
                --
                if bit.band(obj_serverEntCCSPlayer:get_flags(), 1) ~= 1 then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "In Air")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Air")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Is Ducking
                --
                --
                if bit.band(obj_serverEntCCSPlayer:get_flags(), 2) == 2 and bit.band(obj_serverEntCCSPlayer:get_flags(), 3) == 3 and bit.band(obj_serverEntCCSPlayer:get_flags(), 4) == 4 then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Ducking")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Ducking")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Is In Water
                --
                --
                if bit.band(obj_serverEntCCSPlayer:get_flags(), 10) == 10 then
                    local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "In Water")

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosX - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosY + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Water")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
            end
        else
            local i_serverEntCCSPlayer_ScreenBoundingBox = func_extesp_getBoundingBoxStatic(entIndex_serverEntCCSPlayer)
            if i_serverEntCCSPlayer_ScreenBoundingBox.onScreen == false then
                return
            end
            local i_serverEntCCSPlayer_ScreenPosTop = {x = i_serverEntCCSPlayer_ScreenBoundingBox.x + math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.width / 2), y = i_serverEntCCSPlayer_ScreenBoundingBox.y - 4}
            local i_serverEntCCSPlayer_ScreenPosBottom = {x = i_serverEntCCSPlayer_ScreenBoundingBox.x + math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.width / 2), y = i_serverEntCCSPlayer_ScreenBoundingBox.y + i_serverEntCCSPlayer_ScreenBoundingBox.height - 8}
            local i_serverEntCCSPlayer_ScreenPosSideLeft = {x = i_serverEntCCSPlayer_ScreenBoundingBox.x - 8, y = i_serverEntCCSPlayer_ScreenBoundingBox.y}
            local i_serverEntCCSPlayer_ScreenPosSideRight = {x = i_serverEntCCSPlayer_ScreenBoundingBox.x + i_serverEntCCSPlayer_ScreenBoundingBox.width + 5, y = i_serverEntCCSPlayer_ScreenBoundingBox.y}

            --Top
            do
                local i_esp_draw_strOffset = -1

                --
                --
                --  Name
                --
                --
                if ui_get(ref_extesp_name) then
                    local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer_measure_text("b", "Name: " .. obj_serverEntCCSPlayer:get_name())

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_name_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Name: " .. obj_serverEntCCSPlayer:get_name())

                    i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                end

                --
                --
                --  Player State
                --
                --
                if ui_get(ref_extesp_flags) then
                    i_esp_draw_strOffset = i_esp_draw_strOffset - 1

                    --
                    --
                    --  Is Scoped
                    --
                    --
                    if obj_serverEntCCSPlayer:is_scoped() then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Scoped")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, "Scoped")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Is Flashed
                    --
                    --
                    if obj_serverEntCCSPlayer:is_flashed() then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Flashed")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 193, 240, 255, 255, "b", 0, "Flashed")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Has Bomb
                    --
                    --
                    if obj_serverEntCCSPlayer:has_bomb() then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Bombcarrier")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 127, 0, 255, "b", 0, "Bombcarrier")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Has Defuser
                    --
                    --
                    if obj_serverEntCCSPlayer:has_defuser() then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Has Kit")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 0, 127, 255, 255, "b", 0, "Has Kit")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Is In Air
                    --
                    --
                    if bit.band(obj_serverEntCCSPlayer:get_flags(), 1) ~= 1 then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "In Air")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Air")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Is Ducking
                    --
                    --
                    if bit.band(obj_serverEntCCSPlayer:get_flags(), 2) == 2 and bit.band(obj_serverEntCCSPlayer:get_flags(), 3) == 3 and bit.band(obj_serverEntCCSPlayer:get_flags(), 4) == 4 then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "Ducking")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Ducking")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                    --
                    --
                    --  Is In Water
                    --
                    --
                    if bit.band(obj_serverEntCCSPlayer:get_flags(), 10) == 10 then
                        local i_esp_draw_state_strSizeX, i_esp_draw_state_strSizeY = renderer_measure_text("b", "In Water")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, i_esp_draw_state_strSizeX + 8, i_esp_draw_state_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosTop.x - i_esp_draw_state_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosTop.y + i_esp_draw_state_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "In Water")

                        i_esp_draw_strOffset = i_esp_draw_strOffset - 1
                    end
                end
            end

            --Bottom
            do
                local i_esp_draw_strOffset = 1

                --
                --
                --  Distance
                --
                --
                if ui_get(ref_extesp_distance) ~= "Off" then
                    local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

                    local value = math.sqrt((i_serverEntCCSPlayer_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCCSPlayer_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCCSPlayer_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
                    local valueUnit = " u."

                    if ui_get(ref_extesp_distance) == "Metric" then
                        value = value * 0.01905
                        valueUnit = " m."
                    end

                    if ui_get(ref_extesp_distance) == "Imperial" then
                        value = value * 0.075
                        valueUnit = " ft."
                    end

                    local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer_measure_text("b", "Distance: " .. string.format("%d", value) .. valueUnit)

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosBottom.x - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosBottom.y + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosBottom.x - i_esp_draw_distance_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosBottom.y + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. valueUnit)

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end

                --
                --
                --  Weapons
                --
                --
                if ui_get(ref_extesp_equipment) then
                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1

                    local arr_esp_draw_weapons = obj_serverEntCCSPlayer:get_all_weapons()
                    for i = 1, #arr_esp_draw_weapons do
                        local ent_esp_draw_weapon = arr_esp_draw_weapons[i]

                        local str_esp_draw_weapon = ""

                        if ui_get(ref_extesp_ammo) and not(ent_esp_draw_weapon:is_knife()) and ent_esp_draw_weapon:get_current_ammo() ~= nil and ent_esp_draw_weapon:get_max_ammo() ~= nil then
                            str_esp_draw_weapon = ent_esp_draw_weapon:get_name() .. " (" .. ent_esp_draw_weapon:get_current_ammo() .. "/" .. ent_esp_draw_weapon:get_max_ammo() .. ")"
                        else
                            str_esp_draw_weapon = ent_esp_draw_weapon:get_name()
                        end

                        local i_esp_draw_weapon_strSizeX, i_esp_draw_weapon_strSizeY = renderer_measure_text("b", str_esp_draw_weapon)

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosBottom.x - i_esp_draw_weapon_strSizeX / 2 - 4, i_serverEntCCSPlayer_ScreenPosBottom.y + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, i_esp_draw_weapon_strSizeX + 8, i_esp_draw_weapon_strSizeY, 0, 0, 0, 127)

                        if ent_esp_draw_weapon:get_index() == obj_serverEntCCSPlayer:get_active_weapon():get_index() then
                            renderer_text(i_serverEntCCSPlayer_ScreenPosBottom.x - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosBottom.y + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 0, 255, "b", 0, str_esp_draw_weapon)
                        else
                            renderer_text(i_serverEntCCSPlayer_ScreenPosBottom.x - i_esp_draw_weapon_strSizeX / 2, i_serverEntCCSPlayer_ScreenPosBottom.y + i_esp_draw_weapon_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_weapon)
                        end

                        i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                    end
                end
            end

            --Side Left
            do
                local i_esp_draw_strOffset = 0

                --
                --
                --  Health
                --
                --
                if ui_get(ref_extesp_health) then
                    local i_esp_draw_health_strSizeX, i_esp_draw_health_strSizeY = renderer_measure_text("b", "HP: " .. obj_serverEntCCSPlayer:get_health() .. "%")

                    
                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosSideLeft.x - 4, i_serverEntCCSPlayer_ScreenPosSideLeft.y, 6, i_serverEntCCSPlayer_ScreenBoundingBox.height + 1, 0, 0, 0, 127)
                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosSideLeft.x - 3, i_serverEntCCSPlayer_ScreenPosSideLeft.y + 1 + (i_serverEntCCSPlayer_ScreenBoundingBox.height - math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100)), 4, math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100) - 1, 255 - 255 * obj_serverEntCCSPlayer:get_health() / 100, 255 * obj_serverEntCCSPlayer:get_health() / 100, 0, 255)
                    
                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosSideLeft.x - i_esp_draw_health_strSizeX - 12, i_serverEntCCSPlayer_ScreenPosSideLeft.y + i_esp_draw_health_strSizeY * i_esp_draw_strOffset + (i_serverEntCCSPlayer_ScreenBoundingBox.height - math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100)), i_esp_draw_health_strSizeX + 8, i_esp_draw_health_strSizeY, 0, 0, 0, 127)
                    renderer_text(i_serverEntCCSPlayer_ScreenPosSideLeft.x - 8, i_serverEntCCSPlayer_ScreenPosSideLeft.y + i_esp_draw_health_strSizeY * i_esp_draw_strOffset + (i_serverEntCCSPlayer_ScreenBoundingBox.height - math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100)), 255 - 255 * obj_serverEntCCSPlayer:get_health() / 100, 255 * obj_serverEntCCSPlayer:get_health() / 100, 0, 255, "br", 0, "HP: " .. obj_serverEntCCSPlayer:get_health() .. "%")

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
                --
                --
                --  Armor
                --
                --
                if ui_get(ref_extesp_armor) then
                    if obj_serverEntCCSPlayer:playerresource():get_armor() > 0 then
                        local i_esp_draw_armor_strSizeX, i_esp_draw_armor_strSizeY = renderer_measure_text("b", "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                        renderer_rectangle(i_serverEntCCSPlayer_ScreenPosSideLeft.x - i_esp_draw_armor_strSizeX - 12, i_serverEntCCSPlayer_ScreenPosSideLeft.y + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset + (i_serverEntCCSPlayer_ScreenBoundingBox.height - math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100)), i_esp_draw_armor_strSizeX + 8, i_esp_draw_armor_strSizeY, 0, 0, 0, 127)

                        renderer_text(i_serverEntCCSPlayer_ScreenPosSideLeft.x - 8, i_serverEntCCSPlayer_ScreenPosSideLeft.y + i_esp_draw_armor_strSizeY * i_esp_draw_strOffset + (i_serverEntCCSPlayer_ScreenBoundingBox.height - math_floor(i_serverEntCCSPlayer_ScreenBoundingBox.height * obj_serverEntCCSPlayer:get_health() / 100)), 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 127 + 127 * obj_serverEntCCSPlayer:playerresource():get_armor() / 100, 255, "br", 0, "Armor: " .. obj_serverEntCCSPlayer:playerresource():get_armor() .. "%")

                        i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                    end
                end
            end

            --Side Right
            do
                local i_esp_draw_strOffset = 0

                --
                --
                --  NAV Location
                --
                --
                if ui_get(ref_extesp_navlocation) then
                    local str_esp_draw_navlocation = entity_get_prop(entIndex_serverEntCCSPlayer, "m_szLastPlaceName", array_index)

                    local i_esp_draw_navlocation_strSizeX, i_esp_draw_navlocation_strSizeY = renderer_measure_text("b", "Location: " .. str_esp_draw_navlocation)

                    renderer_rectangle(i_serverEntCCSPlayer_ScreenPosSideRight.x, i_serverEntCCSPlayer_ScreenPosSideRight.y + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, i_esp_draw_navlocation_strSizeX + 8, i_esp_draw_navlocation_strSizeY, 0, 0, 0, 127)

                    renderer_text(i_serverEntCCSPlayer_ScreenPosSideRight.x + 4, i_serverEntCCSPlayer_ScreenPosSideRight.y + i_esp_draw_navlocation_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Location: " .. str_esp_draw_navlocation)

                    i_esp_draw_strOffset = i_esp_draw_strOffset + 1
                end
            end
        end
    end
end
local func_extesp_CWeaponCSBaseInfo = function(entIndex_serverEntCWeaponCSBase, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCWeaponCSBase = Entity(entIndex_serverEntCWeaponCSBase)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCWeaponCSBase_WorldPos = obj_serverEntCWeaponCSBase:get_vec_origin()

    local i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY = renderer_world_to_screen(i_serverEntCWeaponCSBase_WorldPos.x, i_serverEntCWeaponCSBase_WorldPos.y, i_serverEntCWeaponCSBase_WorldPos.z)

    obj_serverEntCWeaponCSBase = Weapon(entIndex_serverEntCWeaponCSBase)

    if i_serverEntCWeaponCSBase_ScreenPosX ~= nil and i_serverEntCWeaponCSBase_ScreenPosY ~= nil then
        i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY = func_extesp_clampToViewport(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCWeaponCSBase_ScreenPosX, i_serverEntCWeaponCSBase_ScreenPosY, ui_get(ref_extesp_padding))

        local i_esp_draw_strOffset = 1
        --
        --
        --  Name
        --
        --
        if ui_get(ref_extesp_name) then
            local str_esp_draw_weapon = ""

            if ui_get(ref_extesp_ammo) and not(obj_serverEntCWeaponCSBase:is_grenade()) and not(obj_serverEntCWeaponCSBase:is_knife()) and not(string_match(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CSnowball") ~= nil) and not(string_match(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CSensorGrenade") ~= nil) then
                if entity_get_classname(entIndex_serverEntCWeaponCSBase) ~= "CWeaponTaser" then
                    str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. obj_serverEntCWeaponCSBase:get_current_ammo() .. "/" .. obj_serverEntCWeaponCSBase:get_max_ammo() .. ")"
                else
                    if entity_get_prop(entIndex_serverEntCWeaponCSBase, "m_iClip1", array_index) > 0 then
                        str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. "Charged" .. ")"
                    else
                        str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name() .. " (" .. "Empty" .. ")"
                    end
                end
            else
                if string_match(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CSnowball") ~= nil then
                    str_esp_draw_weapon = "Snowball"
                elseif string_match(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CSensorGrenade") ~= nil then
                    str_esp_draw_weapon = "TA Grenade"
                else
                    str_esp_draw_weapon = obj_serverEntCWeaponCSBase:get_name()
                end
            end
            local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer_measure_text("b", str_esp_draw_weapon)

            renderer_rectangle(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

            renderer_text(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_weapon)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Distance
        --
        --
        if ui_get(ref_extesp_distance) ~= "Off" then
            local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

            local value = math.sqrt((i_serverEntCWeaponCSBase_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCWeaponCSBase_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCWeaponCSBase_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
            local valueUnit = " u."

            if ui_get(ref_extesp_distance) == "Metric" then
                value = value * 0.01905
                valueUnit = " m."
            end

            if ui_get(ref_extesp_distance) == "Imperial" then
                value = value * 0.075
                valueUnit = " ft."
            end

            local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer_measure_text("b", "Distance: " .. string.format("%d", value) .. valueUnit)

            renderer_rectangle(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

            renderer_text(i_serverEntCWeaponCSBase_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCWeaponCSBase_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. valueUnit)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
    end
end
local func_extesp_CAnyInfo = function(entIndex_serverEntCAny, accentColor01, accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
    local obj_serverEntCAny = Entity(entIndex_serverEntCAny)
    local obj_localEntCCSPlayer = Player(entIndex_localEntCCSPlayer)

    local i_serverEntCAny_WorldPos = obj_serverEntCAny:get_vec_origin()

    local i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = renderer_world_to_screen(i_serverEntCAny_WorldPos.x, i_serverEntCAny_WorldPos.y, i_serverEntCAny_WorldPos.z)

    if i_serverEntCAny_ScreenPosX ~= nil and i_serverEntCAny_ScreenPosY ~= nil then
        i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY = func_extesp_clampToViewport(i_esp_drawScreenWidth, i_esp_drawScreenHeight, i_esp_anchorPosX, i_esp_anchorPosY, i_serverEntCAny_ScreenPosX, i_serverEntCAny_ScreenPosY, ui_get(ref_extesp_padding))

        local i_esp_draw_strOffset = 1
        --
        --
        --  Name
        --
        --
        if ui_get(ref_extesp_name) then
            local str_esp_draw_name = ""

            local i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY

            if entity_get_classname(entIndex_serverEntCAny) == "CC4" then
                str_esp_draw_name = "C4"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CPlantedC4" then
                -- TODO: Add timer
                str_esp_draw_name = "C4 (Planted)"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CHostage" then
                str_esp_draw_name = "Hostage"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CEconEntity" then
                str_esp_draw_name = "Kit"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CSmokeGrenadeProjectile" then
                str_esp_draw_name = "Smoke"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CSensorGrenadeProjectile" then
                str_esp_draw_name = "TA Grenade"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CSnowballProjectile" then
                str_esp_draw_name = "Snowball"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CDecoyProjectile" then
                str_esp_draw_name = "Decoy"
            elseif entity_get_classname(entIndex_serverEntCAny) == "CMolotovProjectile" then
                if entity_get_prop(entIndex_serverEntCAny, "m_nModelIndex", array_index) == 39 then
                    str_esp_draw_name = "Incendiary"
                else
                    str_esp_draw_name = "Molotov"
                end
            elseif entity_get_classname(entIndex_serverEntCAny) == "CBaseCSGrenadeProjectile" then
                if entity_get_prop(entIndex_serverEntCAny, "m_nModelIndex", array_index) == 41 then
                    str_esp_draw_name = "HE Grenade"
                else
                    str_esp_draw_name = "Flashbang"
                end
            else
                str_esp_draw_name = obj_serverEntCAny:get_classname()
            end

            i_esp_draw_name_strSizeX, i_esp_draw_name_strSizeY = renderer_measure_text("b", str_esp_draw_name)

            renderer_rectangle(i_serverEntCAny_ScreenPosX - i_esp_draw_name_strSizeX / 2 - 4, i_serverEntCAny_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, i_esp_draw_name_strSizeX + 8, i_esp_draw_name_strSizeY, 0, 0, 0, 127)

            renderer_text(i_serverEntCAny_ScreenPosX - i_esp_draw_name_strSizeX / 2, i_serverEntCAny_ScreenPosY + i_esp_draw_name_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, str_esp_draw_name)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
        --
        --
        --  Distance
        --
        --
        if ui_get(ref_extesp_distance) ~= "Off" then
            local i_localEntCCSPlayer_WorldPos = obj_localEntCCSPlayer:get_vec_origin()

            local value = math.sqrt((i_serverEntCAny_WorldPos.x - i_localEntCCSPlayer_WorldPos.x) ^ 2 + (i_serverEntCAny_WorldPos.y - i_localEntCCSPlayer_WorldPos.y) ^ 2 + (i_serverEntCAny_WorldPos.z - i_localEntCCSPlayer_WorldPos.z) ^ 2)
            local valueUnit = " u."

            if ui_get(ref_extesp_distance) == "Metric" then
                value = value * 0.01905
                valueUnit = " m."
            end

            if ui_get(ref_extesp_distance) == "Imperial" then
                value = value * 0.075
                valueUnit = " ft."
            end

            local i_esp_draw_distance_strSizeX, i_esp_draw_distance_strSizeY = renderer_measure_text("b", "Distance: " .. string.format("%d", value) .. valueUnit)

            renderer_rectangle(i_serverEntCAny_ScreenPosX - i_esp_draw_distance_strSizeX / 2 - 4, i_serverEntCAny_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, i_esp_draw_distance_strSizeX + 8, i_esp_draw_distance_strSizeY, 0, 0, 0, 127)

            renderer_text(i_serverEntCAny_ScreenPosX - i_esp_draw_distance_strSizeX / 2, i_serverEntCAny_ScreenPosY + i_esp_draw_distance_strSizeY * i_esp_draw_strOffset, 255, 255, 255, 255, "b", 0, "Distance: " .. string.format("%d", value) .. valueUnit)

            i_esp_draw_strOffset = i_esp_draw_strOffset + 1
        end
    end
end
function func_extesp_eDraw(ctx)
    local arr = ui_get(ref_extesp_filter_playersSubtype);

    if not ui_get(ref_extesp_enable) then
        return
    end

    local i_esp_anchorPosX = math_floor(i_esp_drawScreenWidth * (ui_get(ref_extesp_snaplineStartX) / 100))
    local i_esp_anchorPosY = math_floor(i_esp_drawScreenHeight * (ui_get(ref_extesp_snaplineStartY) / 100))
    i_esp_anchorPosX = math_min(i_esp_drawScreenWidth - ui_get(ref_extesp_padding), math_max(ui_get(ref_extesp_padding), i_esp_anchorPosX))
    i_esp_anchorPosY = math_min(i_esp_drawScreenHeight - ui_get(ref_extesp_padding), math_max(ui_get(ref_extesp_padding), i_esp_anchorPosY))

    local f_extesp_globalRealtime = globals.realtime()
    b_esp_filter_mapObjective_accentColor01 = func_extesp_rainbowise(4, 255, 1, 0, 255, f_extesp_globalRealtime, 0, 127)
    b_esp_filter_mapObjective_accentColor02 = func_extesp_rainbowise(4, 255, 1, 0, 255, f_extesp_globalRealtime, 0, 255)
    b_esp_filter_mapObjective_accentColor01[4] = 255
    b_esp_filter_mapObjective_accentColor02[4] = 255

    local array_index = {}
    local entIndex_localEntCCSPlayer = entity_get_local_player()
    local entIndex_localEntCCSPlayer_kTeamid = entity_get_prop(entIndex_localEntCCSPlayer, "m_iTeamNum", array_index)

    if ui_get(ref_extesp_filter_players) ~= "Off" then
        local arr_entIndex_serverEntCCSPlayer = entity_get_players(false)
        if ui_get(ref_extesp_filter_players) == "On (Ally/Enemy)" and not(entIndex_localEntCCSPlayer_kTeamid == 1) and not(entIndex_localEntCCSPlayer_kTeamid == 0) then --Differentiate by relationship
            for i = 1, #arr_entIndex_serverEntCCSPlayer do
                local entIndex_serverEntCCSPlayer = arr_entIndex_serverEntCCSPlayer[i]
                local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)

                if obj_serverEntCCSPlayer:is_alive() then
                    local i_serverEntCCSPlayer_kTeamid = obj_serverEntCCSPlayer:get_teamnum()

                    if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "Enemy") then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid ~= entIndex_localEntCCSPlayer_kTeamid then
                            func_extesp_snapline(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02)
                            func_extesp_CCSPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_skeleton(entIndex_serverEntCCSPlayer, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02)
                        end
                    end

                    if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "Ally") then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == entIndex_localEntCCSPlayer_kTeamid then
                            func_extesp_snapline(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02)
                            func_extesp_CCSPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_skeleton(entIndex_serverEntCCSPlayer, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02)
                        end
                    end
                end
            end
        end
        if ui_get(ref_extesp_filter_players) == "On (CT/T)" or entIndex_localEntCCSPlayer_kTeamid == 1 or entIndex_localEntCCSPlayer_kTeamid == 0 then --Differentiate by team
            for i = 1, #arr_entIndex_serverEntCCSPlayer do
                local entIndex_serverEntCCSPlayer = arr_entIndex_serverEntCCSPlayer[i]
                local obj_serverEntCCSPlayer = Player(entIndex_serverEntCCSPlayer)

                if obj_serverEntCCSPlayer:is_alive() then
                    local i_serverEntCCSPlayer_kTeamid = obj_serverEntCCSPlayer:get_teamnum()

                    if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "T") then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == 2 then
                            func_extesp_snapline(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02)
                            func_extesp_CCSPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_skeleton(entIndex_serverEntCCSPlayer, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02)
                        end
                    end

                    if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "CT") then
                        if entIndex_serverEntCCSPlayer ~= entIndex_localEntCCSPlayer and i_serverEntCCSPlayer_kTeamid == 3 then
                            func_extesp_snapline(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02)
                            func_extesp_CCSPlayerInfo(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_skeleton(entIndex_serverEntCCSPlayer, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02)
                        end
                    end
                end
            end
        end
    end

    if ui_get(ref_extesp_filter_weapons) then
        local arr_entIndex_serverEntCWeaponCSBase = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCWeaponCSBase do
            local entIndex_serverEntCWeaponCSBase = arr_entIndex_serverEntCWeaponCSBase[i]

            local obj_serverEntCWeaponCSBase = Entity(entIndex_serverEntCWeaponCSBase) ---------------------------------------------------!!!!!!!!!

            if (string_find(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CWeapon") ~= nil or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CDEagle" or 
                string_find(entity_get_classname(entIndex_serverEntCWeaponCSBase), "CKnife") ~= nil or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CMolotovGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CIncendiaryGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CHEGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CFlashbang" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CSensorGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CSmokeGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CDecoyGrenade" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CSnowball" or 
                entity_get_classname(entIndex_serverEntCWeaponCSBase) == "CAK47") and entity_get_prop(entIndex_serverEntCWeaponCSBase, "m_hOwner", array_index) == nil then
                func_extesp_snapline(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_extesp_boundingBoxStatic(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02)
                func_extesp_CWeaponCSBaseInfo(entIndex_serverEntCWeaponCSBase, b_esp_filter_weapons_accentColor01, b_esp_filter_weapons_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
            end
        end
    end

    if ui_get(ref_extesp_filter_mapObjective) then
        local arr_entIndex_serverEntCAny = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCAny do
            local entIndex_serverEntCAny = arr_entIndex_serverEntCAny[i]

            if (entity_get_classname(entIndex_serverEntCAny) == "CC4" and entity_get_prop(entIndex_serverEntCAny, "m_hOwner", array_index) == nil) or 
                (entity_get_classname(entIndex_serverEntCAny) == "CHostage") or
                (entity_get_classname(entIndex_serverEntCAny) == "CEconEntity" and entIndex_localEntCCSPlayer_kTeamid ~= 2) or
                entity_get_classname(entIndex_serverEntCAny) == "CPlantedC4" then
                func_extesp_snapline(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_extesp_boundingBoxStatic(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02)
                func_extesp_CAnyInfo(entIndex_serverEntCAny, b_esp_filter_mapObjective_accentColor01, b_esp_filter_mapObjective_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
            end
        end
    end

    if ui_get(ref_extesp_filter_projectiles) ~= "Off" then
        local arr_entIndex_serverEntCProjectile = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCProjectile do
            local entIndex_serverEntCProjectile = arr_entIndex_serverEntCProjectile[i]

            if ui_get(ref_extesp_filter_projectiles) == "On (Owner)" then --Differentiate by owner
                if entity_get_classname(entIndex_serverEntCProjectile) == "CSmokeGrenadeProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CSensorGrenadeProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CSnowballProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CMolotovProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CDecoyProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CBaseCSGrenadeProjectile" then

                    if entity_get_prop(entIndex_serverEntCProjectile, "m_hThrower", array_index) ~= 0 and entity_get_prop(entIndex_serverEntCProjectile, "m_hThrower", array_index) ~= nil then
                        local i_serverEntCProjectile_kTeamid = entity_get_prop(entity_get_prop(entIndex_serverEntCProjectile, "m_hThrower", array_index), "m_iTeamNum", array_index)

                        if ui_get(ref_extesp_filter_players) == "On (Ally/Enemy)" and not(entIndex_localEntCCSPlayer_kTeamid == 1) and not(entIndex_localEntCCSPlayer_kTeamid == 0) then --Differentiate by relationship
                            if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "Enemy") then
                                if i_serverEntCProjectile_kTeamid ~= entIndex_localEntCCSPlayer_kTeamid then
                                    func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                    func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02)
                                    func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_playerEnemy_accentColor01, b_esp_filter_playerEnemy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                end
                            end

                            if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "Ally") then
                                if i_serverEntCProjectile_kTeamid == entIndex_localEntCCSPlayer_kTeamid then
                                    func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                    func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02)
                                    func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_playerAlly_accentColor01, b_esp_filter_playerAlly_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                end
                            end
                        end

                        if ui_get(ref_extesp_filter_players) == "On (CT/T)" or entIndex_localEntCCSPlayer_kTeamid == 1 or entIndex_localEntCCSPlayer_kTeamid == 0 then --Differentiate by team
                            if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "T") then
                                if i_serverEntCProjectile_kTeamid == 2 then
                                    func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                    func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02)
                                    func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_playerT_accentColor01, b_esp_filter_playerT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                end
                            end

                            if table_contains_str(ui_get(ref_extesp_filter_playersSubtype), "CT") then
                                if i_serverEntCProjectile_kTeamid == 3 then
                                    func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                    func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02)
                                    func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_playerCT_accentColor01, b_esp_filter_playerCT_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                end
                            end
                        end

                    end
                end
            end

            if ui_get(ref_extesp_filter_projectiles) == "On (Subtype)" then --Differentiate by Subtype
                if entity_get_classname(entIndex_serverEntCProjectile) == "CSmokeGrenadeProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CSensorGrenadeProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CSnowballProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CMolotovProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CDecoyProjectile" or
                entity_get_classname(entIndex_serverEntCProjectile) == "CBaseCSGrenadeProjectile" then

                    if entity_get_prop(entIndex_serverEntCProjectile, "m_hThrower", array_index) ~= 0 and entity_get_prop(entIndex_serverEntCProjectile, "m_hThrower", array_index) ~= nil then

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CSmokeGrenadeProjectile" then
                            func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSmokeG_accentColor01, b_esp_filter_projectile_stSmokeG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSmokeG_accentColor01, b_esp_filter_projectile_stSmokeG_accentColor02)
                            func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSmokeG_accentColor01, b_esp_filter_projectile_stSmokeG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                        end

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CSensorGrenadeProjectile" then
                            func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stTAG_accentColor01, b_esp_filter_projectile_stTAG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stTAG_accentColor01, b_esp_filter_projectile_stTAG_accentColor02)
                            func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stTAG_accentColor01, b_esp_filter_projectile_stTAG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                        end

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CSnowballProjectile" then
                            func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSnowball_accentColor01, b_esp_filter_projectile_stSnowball_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSnowball_accentColor01, b_esp_filter_projectile_stSnowball_accentColor02)
                            func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stSnowball_accentColor01, b_esp_filter_projectile_stSnowball_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                        end

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CMolotovProjectile" then
                            func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stMolotov_accentColor01, b_esp_filter_projectile_stMolotov_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stMolotov_accentColor01, b_esp_filter_projectile_stMolotov_accentColor02)
                            func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stMolotov_accentColor01, b_esp_filter_projectile_stMolotov_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                        end

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CDecoyProjectile" then
                            func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stDecoy_accentColor01, b_esp_filter_projectile_stDecoy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stDecoy_accentColor01, b_esp_filter_projectile_stDecoy_accentColor02)
                            func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stDecoy_accentColor01, b_esp_filter_projectile_stDecoy_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                        end

                        if entity_get_classname(entIndex_serverEntCProjectile) == "CBaseCSGrenadeProjectile" then
                            if entity_get_prop(entIndex_serverEntCProjectile, "m_nModelIndex", array_index) == 41 then
                                func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stHEG_accentColor01, b_esp_filter_projectile_stHEG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stHEG_accentColor01, b_esp_filter_projectile_stHEG_accentColor02)
                                func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stHEG_accentColor01, b_esp_filter_projectile_stHEG_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                            else
                                func_extesp_snapline(entIndex_serverEntCProjectile, b_esp_filter_projectile_stFlashbang_accentColor01, b_esp_filter_projectile_stFlashbang_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                                func_extesp_boundingBoxStatic(entIndex_serverEntCProjectile, b_esp_filter_projectile_stFlashbang_accentColor01, b_esp_filter_projectile_stFlashbang_accentColor02)
                                func_extesp_CAnyInfo(entIndex_serverEntCProjectile, b_esp_filter_projectile_stFlashbang_accentColor01, b_esp_filter_projectile_stFlashbang_accentColor02s, i_esp_anchorPosX, i_esp_anchorPosY)
                            end
                        end
                    end
                end
            end
        end
    end

    if ui_get(ref_extesp_filter_other) then
        local arr_entIndex_serverEntCAny = entity.get_all()
        for i = 1, #arr_entIndex_serverEntCAny do
            local entIndex_serverEntCAny = arr_entIndex_serverEntCAny[i]

            if (string_find(entity_get_classname(entIndex_serverEntCAny), "CWeapon") == nil and                         -- filter out most weapons
                not(entity_get_classname(entIndex_serverEntCAny) == "CDEagle") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CAK47") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CC4") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CHostage") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CEconEntity") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CPlantedC4") and
                string_find(entity_get_classname(entIndex_serverEntCAny), "CKnife") == nil and                          -- filter out most knives
                string_find(entity_get_classname(entIndex_serverEntCAny), "CSmokeGrenade") == nil and                   -- filter out SmokeG and it's projectile
                string_find(entity_get_classname(entIndex_serverEntCAny), "CSensorGrenade") == nil and                  -- filter out TAG and it's projectile
                string_find(entity_get_classname(entIndex_serverEntCAny), "CMolotov") == nil and                        -- filter out Molotov and it's projectile
                string_find(entity_get_classname(entIndex_serverEntCAny), "CDecoy") == nil and                          -- filter out Decoy and it's projectile
                string_find(entity_get_classname(entIndex_serverEntCAny), "CSnowball") == nil and                       -- filter out Decoy and it's projectile
                not(entity_get_classname(entIndex_serverEntCAny) == "CIncendiaryGrenade") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CBaseCSGrenadeProjectile") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CHEGrenade") and
                not(entity_get_classname(entIndex_serverEntCAny) == "CFlashbang") and
                string_find(entity_get_classname(entIndex_serverEntCAny), "CCSPlayer") == nil and                       -- filter out all players and CCSPlayerResource which does not have origin
                string_find(entity_get_classname(entIndex_serverEntCAny), "CCSTeam") == nil and                         -- entity which does not have origin
                string_find(entity_get_classname(entIndex_serverEntCAny), "CCSGameRulesProxy") == nil) then             -- entity which does not have origin
                func_extesp_snapline(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
                func_extesp_boundingBoxStatic(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02)
                func_extesp_CAnyInfo(entIndex_serverEntCAny, b_esp_filter_other_accentColor01, b_esp_filter_other_accentColor02, i_esp_anchorPosX, i_esp_anchorPosY)
            end
        end
    end
end

client.set_event_callback("paint", func_extesp_eDraw)

-- [End of file] -----------------------------------------------------------------------------------------------------------------------------------------------