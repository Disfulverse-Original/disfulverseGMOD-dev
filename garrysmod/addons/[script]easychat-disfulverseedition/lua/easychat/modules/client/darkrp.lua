if gmod.GetGamemode().Name ~= "DarkRP" then return "DarkRP Compat" end

local color_white = color_white

hook.Add("ECPostInitialized", "EasyChatModuleDarkRP", function()
	-- this is for the best
	function GAMEMODE:OnPlayerChat(ply, msg, is_team, is_dead, prefix, col1, col2)
		local msg_components = {}

        -- Check if the message originated from the /ano command
        if string.sub(msg, 1, string.len("/ano")) == "/ano" then
            -- Extract the message content after "/ano "
            --print("it works")
            print(message)
            local message = string.Trim(string.sub(msg, string.len("/ano") + 1))

            -- Customize message formatting for /ano command
            table.insert(msg_components, color_white) -- Reset color

            -- Add the formatted message for /ano command
            table.insert(msg_components, Color(0, 0, 0, 255)) -- Black color for incognito tag
            table.insert(msg_components, "[Инкогнито] ") -- Incognito tag
            table.insert(msg_components, Color(61, 0, 0)) -- Dark red color for message
            table.insert(msg_components, message) -- Message content

            chat.AddText(unpack(msg_components))

            return true -- Prevent default chat message handling
        end	


		-- I don't trust this gamemode at all.
		col1 = col1 or color_white
		col2 = col2 or color_white

		table.insert(msg_components, color_white) -- we don't want previous colors to be used again

		if is_dead then
			EasyChat.AddDeadTag(msg_components)
		end

		EasyChat.AddNameTags(ply, msg_components)

		-- Check if prefix is a string, as some text modifiers can return odd things here.
		if type(prefix) == "string" then
			if col1 == team.GetColor(ply:Team()) then -- Just prettier
				col1 = color_white
			end

			table.insert(msg_components, col1)
			-- Remove the nick appened, use our own system.
			prefix = (prefix:gsub(ply:Nick():PatternSafe(), ""))
			table.insert(msg_components, prefix)
		end

		if IsValid(ply) then
			table.insert(msg_components, ply)
		else
			table.insert(msg_components, Color(110, 247, 177))
			table.insert(msg_components, "???") -- console or weird stuff
		end

		table.insert(msg_components, color_white)
		table.insert(msg_components, ": ")
		table.insert(msg_components, col2)
		table.insert(msg_components, msg)

		chat.AddText(unpack(msg_components))

		return true
	end
end)

return "DarkRP Compat"
