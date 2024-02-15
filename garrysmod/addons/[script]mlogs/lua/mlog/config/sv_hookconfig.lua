--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

mLog.blacklist = mLog.blacklist or {}

--[[
	This file allows you to set certain blacklists for certain hooks.
	
	Each Hook below has a tag next to it with the following meaning:
	
	Entity: the CLASS name of the entity e.g. prop_physics
	Tool: the tool name of the tool gun e.g. precision
	Model: a model path e.g. models/hula.mdl
--]]

// Tool Gun -Tool
mLog.blacklist.tool_gun = {
	// "precision"
}

// Entity Damage - Entity
mLog.blacklist.damage = {
	// "lightsaber"
}

// Props
mLog.blacklist.prop = {
	// "models/hula.mdl"
}