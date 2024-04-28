-- Caches the server's in-game config settings
YAWS.Config.Settings = {
    prefix = {
        default = "Yet Another Warn System >>",
        value = nil,
        type = "string"
    },
    prefix_color = {
        default = Color(83, 182, 155),
        value = nil,
        type = "color"
    },
    broadcast_warns = {
        default = true,
        value = nil,
        type = "boolean"
    },
    point_max = {
        default = 50,
        value = nil,
        type = "number"
    },
    point_cooldown_time = {
        default = 1800, -- 30 minutes
        value = nil,
        type = "number"
    },
    point_cooldown_amount = {
        default = 1,
        value = nil,
        type = "number"
    },
    reason_required = {
        default = false,
        value = nil,
        type = "boolean"
    },
    purge_on_punishment = {
        default = false,
        value = nil,
        type = "boolean"
    },
}
YAWS.Config.SettingOrder = {
    "prefix",
    "prefix_color",
    "broadcast_warns",
    "point_max",
    "point_cooldown_time",
    "point_cooldown_amount",
    "reason_required",
    "purge_on_punishment"
}
-- UI data that isn't sent over for obvious reasons
YAWS.Config.UIData = {
    prefix = {
        name = "admin_settings_prefix_name",
        desc = "admin_settings_prefix_desc"
    },
    prefix_color = {
        name = "admin_settings_prefix_color_name",
        desc = "admin_settings_prefix_color_desc"
    },
    broadcast_warns = {
        name = "admin_settings_broadcast_warns_name",
        desc = "admin_settings_broadcast_warns_desc",
    },
    point_max = {
        name = "admin_settings_point_max_name",
        desc = "admin_settings_point_max_desc",
    },
    point_cooldown_time = {
        name = "admin_settings_point_cooldown_time_name",
        desc = "admin_settings_point_cooldown_time_desc",
    },
    point_cooldown_amount = {
        name = "admin_settings_point_cooldown_amount_name",
        desc = "admin_settings_point_cooldown_amount_desc",
    },
    reason_required = {
        name = "admin_settings_reason_required_name",
        desc = "admin_settings_reason_required_desc",
    },
    purge_on_punishment = {
        name = "admin_settings_purge_on_punishment_name",
        desc = "admin_settings_purge_on_punishment_desc",
    },
}

hook.Add("InitPostEntity", "yaws.config.ready", function()
    net.Start("yaws.config.cacherequest")
    net.SendToServer()
end)


net.Receive("yaws.config.cache", function(len)
    YAWS.Core.PayloadDebug("yaws.config.cache", len)

    local length = net.ReadUInt(16)
    local data = util.JSONToTable(util.Decompress(net.ReadData(length)))

    YAWS.Config.Settings = data
end)

function YAWS.Config.GetValue(key)
    if(!YAWS.Config.Settings[key]) then return end

    if(YAWS.Config.Settings[key].value == nil) then
        return YAWS.Config.Settings[key].default
    end
    return YAWS.Config.Settings[key].value
end 